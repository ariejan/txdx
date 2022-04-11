import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jiffy/jiffy.dart';
import 'package:txdx/txdx/txdx_item.dart';

void main() {
  group('extract contexts', () {
    test('empty task', () {
      final item = TxDxItem.fromText('');
      expect(item.contexts, isEmpty);
    });

    test('task without contexts', () {
      final item = TxDxItem.fromText('do something');
      expect(item.contexts, isEmpty);
    });

    test('task with a single context', () {
      final item = TxDxItem.fromText('do something @work');
      expect(item.contexts, contains('@work'));
    });

    test('task with multiple contexts', () {
      final item = TxDxItem.fromText('do something @work @home');
      expect(item.contexts, containsAll(['@work', '@home']));
    });
  });

  group('extract projects', () {
    test('empty task', () {
      final item = TxDxItem.fromText('');
      expect(item.projects, isEmpty);
    });

    test('task without projects', () {
      final item = TxDxItem.fromText('do something');
      expect(item.projects, isEmpty);
    });

    test('task with a single projects', () {
      final item = TxDxItem.fromText('do something +report');
      expect(item.projects, contains('+report'));
    });

    test('task with multiple projects', () {
      final item = TxDxItem.fromText('do something +report +analysis');
      expect(item.projects, containsAll(['+report', '+analysis']));
    });
  });

  group('extract priority', () {
    test('empty task', () {
      final item = TxDxItem.fromText('');
      expect(item.priority, isNull);
    });

    test('task without priority', () {
      final item = TxDxItem.fromText('do something');
      expect(item.priority, isNull);
    });

    test('task with priority A', () {
      final item = TxDxItem.fromText('(A) do something');
      expect(item.priority, equals('A'));
    });

    test('task with priority B', () {
      final item = TxDxItem.fromText('(B) do something');
      expect(item.priority, equals('B'));
    });
  });

  group('extract created on', ()
  {
    test('empty task', () {
      final item = TxDxItem.fromText('');
      expect(item.createdOn, isNull);
    });

    test('task without a date', () {
      final item = TxDxItem.fromText('do something');
      expect(item.createdOn, isNull);
    });

    test('task with a created date', () {
      final item = TxDxItem.fromText('2016-03-29 do something');
      expect(item.createdOn, equals(DateTime(2016, 3, 29)));
    });

    test('prioritized task with a created date', () {
      final item = TxDxItem.fromText('(A) 2016-03-29 do something');
      expect(item.createdOn, equals(DateTime(2016, 3, 29)));
    });

    test('date included in task text', () {
      final item = TxDxItem.fromText('(A) do something 2016-03-29');
      expect(item.createdOn, isNull);
    });
  });

  group('extract completion date', () {
    test('empty task', () {
      final item = TxDxItem.fromText('');
      expect(item.completedOn, isNull);
    });

    test('task without a creation or completion date', () {
      final item = TxDxItem.fromText('do something');
      expect(item.completedOn, isNull);
    });

    test('task without completion date', () {
      final item = TxDxItem.fromText('2016-03-29 do something');
      expect(item.completedOn, isNull);
    });

    test('task with a completion date', () {
      final item = TxDxItem.fromText('2016-04-01 2016-03-29 do something');
      expect(item.createdOn, equals(DateTime(2016, 4, 1)));
    });

    test('prioritized task with a completion date', () {
      final item = TxDxItem.fromText('(A) 2016-04-01 2016-03-29 do something');
      expect(item.createdOn, equals(DateTime(2016, 4, 1)));
    });
  });

  group('extract completed flag', () {
    test('empty task', () {
      final item = TxDxItem.fromText('');
      expect(item.completed, false);
    });

    test('uncompleted task', () {
      final item = TxDxItem.fromText('2016-03-29 do something');
      expect(item.completed, false);
    });

    test('completed task without a date', () {
      final item = TxDxItem.fromText('x do something');
      expect(item.completed, true);
    });

    test('completed task with a date', () {
      final item = TxDxItem.fromText('x 2016-03-29 do something');
      expect(item.completed, true);
    });
  });

  group('extract due date', () {
    test('empty task', () {
      final item = TxDxItem.fromText('');
      expect(item.dueOn, isNull);
    });

    test('task without any tags', () {
      final item = TxDxItem.fromText('do something');
      expect(item.dueOn, isNull);
    });

    test('with a simple due date', () {
      final item = TxDxItem.fromText('do something due:2022-01-18');
      expect(item.dueOn, equals(DateTime(2022, 1, 18)));
    });

    test('with a simple due date and capital key', () {
      final item = TxDxItem.fromText('do something DUE:2022-01-18');
      expect(item.dueOn, equals(DateTime(2022, 1, 18)));
    });

    test('complex due date: today', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      final item = TxDxItem.fromText('do something due:today');
      expect(item.dueOn, equals(today));
    });

    test('complex due date: tomorrow', () {
      final now = DateTime.now();
      final tomorrow = DateTime(now.year, now.month, now.day + 1);

      final item = TxDxItem.fromText('do something due:tomorrow');
      expect(item.dueOn, equals(tomorrow));
    });

    test('complex due date: yesterday', () {
      final now = DateTime.now();
      final yesterday = DateTime(now.year, now.month, now.day - 1);

      final item = TxDxItem.fromText('do something due:yesterday');
      expect(item.dueOn, equals(yesterday));
    });

    test('due modifier syntax', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      expect(TxDxItem.fromText('do it due:4d').dueOn, equals(Jiffy(today).add(days: 4).dateTime));
      expect(TxDxItem.fromText('do it due:12d').dueOn, equals(Jiffy(today).add(days: 12).dateTime));
      expect(TxDxItem.fromText('do it due:3w').dueOn, equals(Jiffy(today).add(weeks: 3).dateTime));
      expect(TxDxItem.fromText('do it due:2m').dueOn, equals(Jiffy(today).add(months: 2).dateTime));
      expect(TxDxItem.fromText('do it due:1y').dueOn, equals(Jiffy(today).add(years: 1).dateTime));
      expect(TxDxItem.fromText('do it due:1w2d').dueOn, equals(Jiffy(today).add(weeks: 1, days: 2).dateTime));
      expect(TxDxItem.fromText('do it due:1y2m3w4d').dueOn, equals(Jiffy(today).add(years: 1, months: 2, weeks: 3, days: 4).dateTime));
    });

    test('handle leap years', () {
      final now = DateTime(2020, 02, 29);
      final target = DateTime(2021, 02, 28);
      withClock(Clock.fixed(now), () {
        expect(TxDxItem.fromText('do it due:1y').dueOn, equals(target));
      });
    });

    test('handle months gracefully', () {
      final now = DateTime(2020, 03, 31);
      final target = DateTime(2020, 04, 30);
      withClock(Clock.fixed(now), () {
        expect(TxDxItem.fromText('do it due:1m').dueOn, equals(target));
      });
    });

    test('due day helpers syntax', () {
      final now = DateTime(2022, 04, 11, 12, 00); // a Monday
      
      final tue = DateTime(now.year, now.month, now.day + 1);
      final wed = DateTime(now.year, now.month, now.day + 2);
      final thu = DateTime(now.year, now.month, now.day + 3);
      final fri = DateTime(now.year, now.month, now.day + 4);
      final sat = DateTime(now.year, now.month, now.day + 5);
      final sun = DateTime(now.year, now.month, now.day + 6);
      final mon = DateTime(now.year, now.month, now.day + 7);

      final expectations = {
        'tue': tue, 'tuesday': tue,
        'wed': wed, 'wednesday': wed,
        'thu': thu, 'thursday': thu,
        'fri': fri, 'friday': fri,
        'sat': sat, 'saturday': sat,
        'sun': sun, 'sunday': sun,
        'mon': mon, 'monday': mon,
      };

      withClock(Clock.fixed(now), () {
        expectations.forEach((day, target) {
          expect(TxDxItem.fromText('do it due:$day').dueOn, equals(Jiffy(target).dateTime));
        });
      });
    });
  });

  group('extract tags', () {
    test('empty task', () {
      final item = TxDxItem.fromText('');
      expect(item.tags, isEmpty);
    });

    test('task without any tags', () {
      final item = TxDxItem.fromText('do something');
      expect(item.tags, isEmpty);
    });

    test('task with a single tags', () {
      final item = TxDxItem.fromText('do something hello:world');
      expect(item.tags, containsPair('hello', 'world'));
    });

    test('task with a multiple tags', () {
      final item = TxDxItem.fromText('do something hello:world foo:bar');
      expect(item.tags, containsPair('hello', 'world'));
      expect(item.tags, containsPair('foo', 'bar'));
    });
  });

  group('extract task text', () {
    test('empty task', () {
      final item = TxDxItem.fromText('');
      expect(item.description, isEmpty);
    });

    test('task without markup', () {
      final item = TxDxItem.fromText('do something');
      expect(item.description, equals('do something'));
    });

    test('task with priority, date, tags, context and project', () {
      final item = TxDxItem.fromText('(A) 2016-03-29 something to do tag:val +experiment @work');
      expect(item.description, equals('something to do'));
    });

    test('completed task with completion date', () {
      final item = TxDxItem.fromText('x 2016-03-30 2016-03-29 something to do +experiment @work');
      expect(item.description, equals('something to do'));
    });

    test('completed task without completion date', () {
      final item = TxDxItem.fromText('x something to do');
      expect(item.description, equals('something to do'));
    });
  });
}