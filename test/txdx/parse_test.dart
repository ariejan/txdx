import 'package:flutter_test/flutter_test.dart';
import 'package:txdx/txdx/txdx.dart';

void main() {
  group('extract contexts', () {
    test('empty task', () {
      final item = TxDxItem('');
      expect(item.contexts, isEmpty);
    });

    test('task without contexts', () {
      final item = TxDxItem('do something');
      expect(item.contexts, isEmpty);
    });

    test('task with a single context', () {
      final item = TxDxItem('do something @work');
      expect(item.contexts, contains('@work'));
    });

    test('task with multiple contexts', () {
      final item = TxDxItem('do something @work @home');
      expect(item.contexts, containsAll(['@work', '@home']));
    });
  });

  group('extract projects', () {
    test('empty task', () {
      final item = TxDxItem('');
      expect(item.projects, isEmpty);
    });

    test('task without projects', () {
      final item = TxDxItem('do something');
      expect(item.projects, isEmpty);
    });

    test('task with a single projects', () {
      final item = TxDxItem('do something +report');
      expect(item.projects, contains('+report'));
    });

    test('task with multiple projects', () {
      final item = TxDxItem('do something +report +analysis');
      expect(item.projects, containsAll(['+report', '+analysis']));
    });
  });

  group('extract priority', () {
    test('empty task', () {
      final item = TxDxItem('');
      expect(item.priority, isNull);
    });

    test('task without priority', () {
      final item = TxDxItem('do something');
      expect(item.priority, isNull);
    });

    test('task with priority A', () {
      final item = TxDxItem('(A) do something');
      expect(item.priority, equals('A'));
    });

    test('task with priority B', () {
      final item = TxDxItem('(B) do something');
      expect(item.priority, equals('B'));
    });
  });

  group('extract created on', ()
  {
    test('empty task', () {
      final item = TxDxItem('');
      expect(item.createdOn, isNull);
    });

    test('task without a date', () {
      final item = TxDxItem('do something');
      expect(item.createdOn, isNull);
    });

    test('task with a created date', () {
      final item = TxDxItem('2016-03-29 do something');
      expect(item.createdOn, equals(DateTime(2016, 3, 29)));
    });

    test('prioritized task with a created date', () {
      final item = TxDxItem('(A) 2016-03-29 do something');
      expect(item.createdOn, equals(DateTime(2016, 3, 29)));
    });

    test('date included in task text', () {
      final item = TxDxItem('(A) do something 2016-03-29');
      expect(item.createdOn, isNull);
    });
  });

  group('extract completion date', () {
    test('empty task', () {
      final item = TxDxItem('');
      expect(item.completedOn, isNull);
    });

    test('task without a creation or completion date', () {
      final item = TxDxItem('do something');
      expect(item.completedOn, isNull);
    });

    test('task without completion date', () {
      final item = TxDxItem('2016-03-29 do something');
      expect(item.completedOn, isNull);
    });

    test('task with a completion date', () {
      final item = TxDxItem('2016-04-01 2016-03-29 do something');
      expect(item.createdOn, equals(DateTime(2016, 4, 1)));
    });

    test('prioritized task with a completion date', () {
      final item = TxDxItem('(A) 2016-04-01 2016-03-29 do something');
      expect(item.createdOn, equals(DateTime(2016, 4, 1)));
    });
  });

  group('extract completed flag', () {
    test('empty task', () {
      final item = TxDxItem('');
      expect(item.completed, false);
    });

    test('uncompleted task', () {
      final item = TxDxItem('2016-03-29 do something');
      expect(item.completed, false);
    });

    test('completed task without a date', () {
      final item = TxDxItem('x do something');
      expect(item.completed, true);
    });

    test('completed task with a date', () {
      final item = TxDxItem('x 2016-03-29 do something');
      expect(item.completed, true);
    });
  });

  group('extract due date', () {
    test('empty task', () {
      final item = TxDxItem('');
      expect(item.dueOn, isNull);
    });

    test('task without any tags', () {
      final item = TxDxItem('do something');
      expect(item.dueOn, isNull);
    });

    test('task with a due date', () {
      final item = TxDxItem('do something due:2022-01-18');
      expect(item.dueOn, equals(DateTime(2022, 1, 18)));
    });

    test('task with a case-insensitive due date', () {
      final item = TxDxItem('do something DUE:2022-01-18');
      expect(item.dueOn, equals(DateTime(2022, 1, 18)));
    });
  });

  group('extract tags', () {
    test('empty task', () {
      final item = TxDxItem('');
      expect(item.tags, isEmpty);
    });

    test('task without any tags', () {
      final item = TxDxItem('do something');
      expect(item.tags, isEmpty);
    });

    test('task with a single tags', () {
      final item = TxDxItem('do something hello:world');
      expect(item.tags, containsPair('hello', 'world'));
    });

    test('task with a multiple tags', () {
      final item = TxDxItem('do something hello:world foo:bar');
      expect(item.tags, containsPair('hello', 'world'));
      expect(item.tags, containsPair('foo', 'bar'));
    });
  });
}