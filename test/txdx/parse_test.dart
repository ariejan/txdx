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
}