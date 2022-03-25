
import 'package:flutter_test/flutter_test.dart';
import 'package:txdx/txdx/txdx_item.dart';

void main() {
  group('equality', () {
    test('for equal items', () {
      const taskText = '(A) 2022-01-15 Do the thing due:2022-01-31 +finance @work';

      final itemA = TxDxItem.fromText(taskText);
      final itemB = TxDxItem.fromText(taskText);
      
      expect(itemA.id, isNot(equals(itemB.id)));
      expect(itemA == itemB, isTrue);
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
}