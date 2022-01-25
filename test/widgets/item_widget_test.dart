
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:txdx/txdx/txdx_item.dart';
import 'package:txdx/widgets/item_widget.dart';

void main() {
    Widget _wrapWidget(Widget widget) {
        return MaterialApp(
            home: Material(
                child: widget,
            )
        );
    }

    group('completed checkbox', () {
        testWidgets('for open task', (tester) async {
            final item = TxDxItem.fromText('(A) 2022-01-18 Buy birthday cake @shopping due:2022-01-18');
            await tester.pumpWidget(_wrapWidget(ItemWidget(item)));
            final checkboxFinder = find.byType(Checkbox);
            var checkbox = tester.firstWidget(checkboxFinder) as Checkbox;
            expect(checkbox.value, isFalse);
        });

        testWidgets('for completed task', (tester) async {
            final item = TxDxItem.fromText('x 2022-01-19 20220-01-18 Buy birthday cake @shopping due:2022-01-18');
            await tester.pumpWidget(_wrapWidget(ItemWidget(item)));
            final checkboxFinder = find.byType(Checkbox);
            var checkbox = tester.firstWidget(checkboxFinder) as Checkbox;
            expect(checkbox.value, isTrue);
        });

        testWidgets('toggle', (tester) async {
            var checkboxChecked = false;

            final item = TxDxItem.fromText('(A) 2022-01-18 Buy birthday cake @shopping due:2022-01-18');
            await tester.pumpWidget(_wrapWidget(
                ItemWidget(
                    item,
                    onCompletedToggle: (value) => checkboxChecked = value,
                )
            ));

            final checkboxFinder = find.byType(Checkbox);

            expect(checkboxChecked, isFalse);
            await tester.tap(checkboxFinder);
            await tester.pumpAndSettle();
            expect(checkboxChecked, isTrue);
        });
    });


}