
import 'package:flutter_test/flutter_test.dart';
import 'package:quiver/core.dart';
import 'package:txdx/txdx/txdx_item.dart';

void main() {
  group('equality', () {
    test('for equal items', () {
      const taskText = '(A) 2022-01-15 Do the thing due:2022-01-31 +finance @work';

      final itemA = TxDxItem.fromText(taskText);
      final itemB = TxDxItem.fromText(taskText);
      
      expect(itemA.id, isNot(equals(itemB.id)));
      expect(itemA == itemB, isTrue);
      expect(itemA.hashCode == itemB.hashCode, isTrue);
      expect(itemA, equals(itemB));
    });

    test('for unequal items', () {
      const taskTextA = '(A) 2022-01-15 Do the thing due:2022-01-31 +finance @work';
      const taskTextB = '(A) 2022-01-15 Do the thing due:2022-01-30 +finance @work';

      final itemA = TxDxItem.fromText(taskTextA);
      final itemB = TxDxItem.fromText(taskTextB);

      expect(itemA.id, isNot(equals(itemB.id)));
      expect(itemA == itemB, isFalse);
      expect(itemA, isNot(equals(itemB)));
    });
  });
  
  group('toString', () {
    test('uncompleted item', () {
      const taskText = '(A) 2022-01-15 Do the thing due:2022-01-31 +finance @work';

      final item = TxDxItem.fromText(taskText);
      final actual = item.toString();

      expect(actual, equals('(A) 2022-01-15 Do the thing @work +finance due:2022-01-31'));
    });

    test('completed item', () {
      const taskText = 'x 2022-01-19 2022-01-15 Do the thing due:2022-01-31 +finance @work';

      final item = TxDxItem.fromText(taskText);
      final actual = item.toString();

      expect(actual, equals('x 2022-01-19 2022-01-15 Do the thing @work +finance due:2022-01-31'));
    });
  });

  group('completion', () {
    test('mark as complete', () {
      final originalItem = TxDxItem.fromText('(A) 2022-01-15 Do the thing +finance @work due:2022-01-31');
      final actualItem = originalItem.toggleComplete();

      expect(actualItem.id, equals(originalItem.id));
      expect(actualItem.completed, isTrue);
      expect(actualItem.priority, isNull);
      expect(actualItem.completedOn, isNotNull);
    });

    test('mark as incomplete', () {
      final originalItem = TxDxItem.fromText('x 2022-01-18 2022-01-15 Do the thing +finance @work due:2022-01-31');
      final actualItem = originalItem.toggleComplete();

      expect(actualItem.id, equals(originalItem.id));
      expect(actualItem.completed, isFalse);
      expect(actualItem.priority, isNull);
      expect(actualItem.completedOn, isNull);
    });
  });

  group('fromText', () {
    test('converts a pending Todo.txt item into a TxDxItem', () {
      final item = TxDxItem.fromText('(E) 2022-01-15 Do the thing +finance @work due:2022-01-31 alt:true');

      expect(item.id, isNotNull);
      expect(item.completed, isFalse);
      expect(item.completedOn, isNull);
      expect(item.createdOn, equals(DateTime(2022, 1, 15)));
      expect(item.priority, equals('E'));
      expect(item.description, equals('Do the thing'));
      expect(item.projects, contains('+finance'));
      expect(item.contexts, contains('@work'));
      expect(item.tags, containsPair('due', '2022-01-31'));
      expect(item.tags, containsPair('alt', 'true'));
      expect(item.tagsWithoutDue, isNot(containsPair('due', '2022-01-31')));
      expect(item.tagsWithoutDue, containsPair('alt', 'true'));
      expect(item.dueOn, equals(DateTime(2022, 1, 31)));
      expect(item.hasDueOn, isTrue);
    });
    test('converts a completed Todo.txt item into a TxDxItem', () {
      final item = TxDxItem.fromText('x 2022-03-17 2022-01-15 Do the thing +finance @work due:2022-01-31 alt:true');

      expect(item.id, isNotNull);
      expect(item.completed, isTrue);
      expect(item.completedOn, equals(DateTime(2022, 3, 17)));
      expect(item.createdOn, equals(DateTime(2022, 1, 15)));
      expect(item.priority, isNull);
      expect(item.description, equals('Do the thing'));
      expect(item.projects, contains('+finance'));
      expect(item.contexts, contains('@work'));
      expect(item.tags, containsPair('due', '2022-01-31'));
      expect(item.tags, containsPair('alt', 'true'));
      expect(item.tagsWithoutDue, isNot(containsPair('due', '2022-01-31')));
      expect(item.tagsWithoutDue, containsPair('alt', 'true'));
      expect(item.dueOn, equals(DateTime(2022, 1, 31)));
      expect(item.hasDueOn, isTrue);
    });
  });

  group('fromTextWithId', () {
    test('converts a pending Todo.txt item into a TxDxItem', () {
      const itemId = 'ITEM-ID-1';
      final item = TxDxItem.fromTextWithId(itemId, '(E) 2022-01-15 Do the thing +finance @work due:2022-01-31 alt:true');

      expect(item.id, equals(itemId));
      expect(item.completed, isFalse);
      expect(item.completedOn, isNull);
      expect(item.createdOn, equals(DateTime(2022, 1, 15)));
      expect(item.priority, equals('E'));
      expect(item.description, equals('Do the thing'));
      expect(item.projects, contains('+finance'));
      expect(item.contexts, contains('@work'));
      expect(item.tags, containsPair('due', '2022-01-31'));
      expect(item.tags, containsPair('alt', 'true'));
      expect(item.tagsWithoutDue, isNot(containsPair('due', '2022-01-31')));
      expect(item.tagsWithoutDue, containsPair('alt', 'true'));
      expect(item.dueOn, equals(DateTime(2022, 1, 31)));
      expect(item.hasDueOn, isTrue);
    });

    test('converts a completed Todo.txt item into a TxDxItem', () {
      const itemId = 'ITEM-ID-1';
      final item = TxDxItem.fromTextWithId(itemId, 'x 2022-03-17 2022-01-15 Do the thing +finance @work due:2022-01-31 alt:true');

      expect(item.id, equals(itemId));
      expect(item.completed, isTrue);
      expect(item.completedOn, equals(DateTime(2022, 3, 17)));
      expect(item.createdOn, equals(DateTime(2022, 1, 15)));
      expect(item.priority, isNull);
      expect(item.description, equals('Do the thing'));
      expect(item.projects, contains('+finance'));
      expect(item.contexts, contains('@work'));
      expect(item.tags, containsPair('due', '2022-01-31'));
      expect(item.tags, containsPair('alt', 'true'));
      expect(item.tagsWithoutDue, isNot(containsPair('due', '2022-01-31')));
      expect(item.tagsWithoutDue, containsPair('alt', 'true'));
      expect(item.dueOn, equals(DateTime(2022, 1, 31)));
      expect(item.hasDueOn, isTrue);
    });
  });

  group('copyWith', () {
    test('copies and item with changed attributes', () {
      final item = TxDxItem.fromText('(E) 2022-01-15 Do the thing +finance @work due:2022-01-31 alt:true');

      final actual = item.copyWith(
        completed: true,
        description: 'Do something else',
        createdOn: DateTime(2022, 3, 1),
        priority: Optional.of('A'),
        completedOn: DateTime(2022, 3, 31),
      );

      expect(actual.id, equals(item.id));
      expect(actual.completed, isTrue);
      expect(actual.description, equals('Do something else'));
      expect(actual.createdOn, equals(DateTime(2022, 3, 1)));
      expect(actual.priority, equals('A'));
      expect(actual.completedOn, equals(DateTime(2022, 3, 31)));
    });

    test('copies an items with a nulled priority', () {
      final item = TxDxItem.fromText('(E) 2022-01-15 Do the thing +finance @work due:2022-01-31 alt:true');
      final actual = item.copyWith(priority: const Optional.fromNullable(null));

      expect(actual.priority, isNull);
    });
  });

  group('prioUp and prioDown', () {
    test('toggle priority up', () {
      final item = TxDxItem.fromText('(C) 2022-01-15 Do the thing +finance @work due:2022-01-31 alt:true');
      expect(item.priority, equals('C'));

      final prioB = item.prioUp();
      expect(prioB.priority, equals('B'));

      final prioA = prioB.prioUp();
      expect(prioA.priority, equals('A'));

      final prioNull = prioA.prioUp();
      expect(prioNull.priority, isNull);

      final prioD = prioNull.prioUp();
      expect(prioD.priority, equals('D'));

      final prioC = prioD.prioUp();
      expect(prioC.priority, equals('C'));
    });

    test('toggle priority down', () {
      final item = TxDxItem.fromText('(C) 2022-01-15 Do the thing +finance @work due:2022-01-31 alt:true');
      expect(item.priority, equals('C'));

      final prioD = item.prioDown();
      expect(prioD.priority, equals('D'));

      final prioNull = prioD.prioDown();
      expect(prioNull.priority, isNull);

      final prioA = prioNull.prioDown();
      expect(prioA.priority, equals('A'));

      final prioB = prioA.prioDown();
      expect(prioB.priority, equals('B'));

      final prioC = prioB.prioDown();
      expect(prioC.priority, equals('C'));
    });
  });

  group('hasContextOrProject', () {
    test('returns the correct status', () {
      expect(TxDxItem.fromText('(C) 2022-01-15 Do the thing +finance @work')
        .hasContextOrProject('@work'),
        isTrue);

    expect(TxDxItem.fromText('(C) 2022-01-15 Do the thing +finance @work')
        .hasContextOrProject('+finance'),
        isTrue);

    expect(TxDxItem.fromText('(C) 2022-01-15 Do the thing +finance @work')
        .hasContextOrProject('@home'),
        isFalse);
    });
  });

  group('hasDueOn', () {
    test('reports if item has a due: tag', () {
      expect(TxDxItem.fromText('(C) 2022-01-15 Do the thing +finance @work')
          .hasDueOn,
          isFalse);

      expect(TxDxItem.fromText('(C) 2022-01-15 Do the thing +finance @work due:2022-02-02')
          .hasDueOn,
          isTrue);
    });
  });

  group('moveToToday', () {
    test('sets due: to today', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      expect(TxDxItem.fromText('(C) 2022-01-15 Do the thing +finance @work')
          .moveToToday().dueOn,
          equals(today));

      expect(TxDxItem.fromText('(C) 2022-01-15 Do the thing +finance @work due:2021-01-01')
          .moveToToday().dueOn,
          equals(today));
    });
  });

  group('postpone', () {
    test('adds n days to due date', () {
      final now = DateTime.now();
      final daysPlus7 = DateTime(now.year, now.month, now.day + 7);

      expect(TxDxItem.fromText('(C) 2022-01-15 Do the thing +finance @work')
          .postpone(7).dueOn,
          equals(daysPlus7));

      expect(TxDxItem.fromText('(C) 2022-01-15 Do the thing +finance @work due:2021-01-01')
          .postpone(7).dueOn,
          equals(daysPlus7));
    });
  });

  group('setPriority', () {
    test('sets new priority', () {
      expect(TxDxItem.fromText('(C) 2022-01-15 Do the thing +finance @work')
          .setPriority('A').priority,
          equals('A'));

      expect(TxDxItem.fromText('(C) 2022-01-15 Do the thing +finance @work')
          .setPriority(null).priority,
          isNull);
    });
  });
}