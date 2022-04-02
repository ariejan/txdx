import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jiffy/jiffy.dart';
import 'package:txdx/providers/items/item_notifier_provider.dart';
import 'package:txdx/txdx/txdx_item.dart';
import 'package:txdx/widgets/items/item_widget.dart';
import 'package:mocktail/mocktail.dart';

import 'test_helpers.dart';

class MockItemNotifier extends Mock implements ItemNotifier {}

void main() {
  group('item description', () {
    testWidgets('for item description visible', (tester) async {
      final item = TxDxItem.fromText(
          '(A) 2022-01-18 Buy birthday cake @shopping due:2022-01-18');
      await tester.pumpWidget(await TestHelpers.wrapWidget(ItemWidget(item)));
      final descriptionWidget = find.text("Buy birthday cake");

      expect(descriptionWidget, findsOneWidget);
    });
  });

  group('projects, contexts and tags', () {
    testWidgets('shows projects', (tester) async {
      final item = TxDxItem.fromText(
          '(A) 2022-01-18 Buy birthday cake @shopping +home who:laura due:2022-02-24');
      await tester.pumpWidget(await TestHelpers.wrapWidget(ItemWidget(item)));
      final theWidget = find.text("+home");

      expect(theWidget, findsOneWidget);
    });

    testWidgets('shows contexts', (tester) async {
      final item = TxDxItem.fromText(
          '(A) 2022-01-18 Buy birthday cake @shopping +home who:laura due:2022-02-24');
      await tester.pumpWidget(await TestHelpers.wrapWidget(ItemWidget(item)));
      final theWidget = find.text("@shopping");

      expect(theWidget, findsOneWidget);
    });

    testWidgets('shows tags', (tester) async {
      final item = TxDxItem.fromText(
          '(A) 2022-01-18 Buy birthday cake @shopping +home who:laura due:2022-02-24');
      await tester.pumpWidget(await TestHelpers.wrapWidget(ItemWidget(item)));
      final theWidget = find.text("who:laura");

      expect(theWidget, findsOneWidget);
    });
  });

  group('dueOn', () {
    testWidgets('shows today', (tester) async {
      final futureDate = DateTime.now();
      final strDate = Jiffy(futureDate).format('yyyy-MM-dd');

      final item = TxDxItem.fromText(
          '(A) 2022-01-18 Buy birthday cake @shopping due:$strDate');
      await tester.pumpWidget(await TestHelpers.wrapWidget(ItemWidget(item)));
      final dueOnWidget = find.text("today");

      expect(dueOnWidget, findsOneWidget);
    });

    testWidgets('shows tomorrow', (tester) async {
      final futureDate = DateTime.now().add(const Duration(days: 1));
      final strDate = Jiffy(futureDate).format('yyyy-MM-dd');

      final item = TxDxItem.fromText(
          '(A) 2022-01-18 Buy birthday cake @shopping due:$strDate');
      await tester.pumpWidget(await TestHelpers.wrapWidget(ItemWidget(item)));
      final dueOnWidget = find.text("tomorrow");

      expect(dueOnWidget, findsOneWidget);
    });

    testWidgets('shows yesterday', (tester) async {
      final futureDate = DateTime.now().subtract(const Duration(days: 1));
      final strDate = Jiffy(futureDate).format('yyyy-MM-dd');

      final item = TxDxItem.fromText(
          '(A) 2022-01-18 Buy birthday cake @shopping due:$strDate');
      await tester.pumpWidget(await TestHelpers.wrapWidget(ItemWidget(item)));
      final dueOnWidget = find.text("yesterday");

      expect(dueOnWidget, findsOneWidget);
    });

    // testWidgets('shows in n days', (tester) async {
    //   final now = DateTime.now();
    //   final futureDate = DateTime(now.year, now.month, now.day + 3);
    //   final strDate = Jiffy(futureDate).format('yyyy-MM-dd');
    //
    //   final item = TxDxItem.fromText(
    //       '(A) 2022-01-18 Buy birthday cake @shopping due:$strDate');
    //   await tester.pumpWidget(await TestHelpers.wrapWidget(ItemWidget(item)));
    //   final dueOnWidget = find.text("in 3 days");
    //
    //   expect(dueOnWidget, findsOneWidget);
    // });
  });

  group('completed checkbox', () {
    testWidgets('for open task', (tester) async {
      final item = TxDxItem.fromText(
          '(A) 2022-01-18 Buy birthday cake @shopping due:2022-01-18');
      await tester.pumpWidget(await TestHelpers.wrapWidget(ItemWidget(item)));
      final checkboxFinder = find.byType(Checkbox);
      var checkbox = tester.firstWidget(checkboxFinder) as Checkbox;
      expect(checkbox.value, isFalse);
    });

    testWidgets('for completed task', (tester) async {
      final item = TxDxItem.fromText(
          'x 2022-01-19 20220-01-18 Buy birthday cake @shopping due:2022-01-18');
      await tester.pumpWidget(await TestHelpers.wrapWidget(ItemWidget(item)));
      final checkboxFinder = find.byType(Checkbox);
      var checkbox = tester.firstWidget(checkboxFinder) as Checkbox;
      expect(checkbox.value, isTrue);
    });

    testWidgets('toggle', (tester) async {
      final item = TxDxItem.fromText('(A) 2022-01-18 Buy birthday cake @shopping due:2022-01-18');
      final mockItemNotifier = MockItemNotifier();

      when(() => mockItemNotifier.toggleComplete(item.id)).thenAnswer((invocation) => Future(() => null));

      await tester.pumpWidget(await TestHelpers.wrapWidget(ItemWidget(item), overrides: [
        itemsNotifierProvider.overrideWithValue(mockItemNotifier),
      ]));

      final checkboxFinder = find.byType(Checkbox);
      await tester.tap(checkboxFinder);
      await tester.pump(const Duration(milliseconds: 500));
      verify(() => mockItemNotifier.toggleComplete(item.id)).called(1);
    });
  });
}
