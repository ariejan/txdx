
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:txdx/widgets/navigation/menu_item_widget.dart';

import 'test_helpers.dart';

void main() {

  testWidgets('shows menu item title', (tester) async {
    await tester.pumpWidget(await TestHelpers.wrapWidget(
      const MenuItemWidget(
          iconData: Icons.check,
          title: 'Menu Item Text',
      ),
    ));

    final textWidget = find.text("Menu Item Text");
    expect(textWidget, findsOneWidget);
  });

  testWidgets('shows menu icon', (tester) async {
    await tester.pumpWidget(await TestHelpers.wrapWidget(
        const MenuItemWidget(
          iconData: Icons.check,
          title: 'Menu Item Text',
        )
    ));

    final iconWidget = find.byType(Icon);
    expect(iconWidget, findsOneWidget);
  });

  testWidgets('handles on tap events', (tester) async {
    var checkTap = false;

    await tester.pumpWidget(await TestHelpers.wrapWidget(
        MenuItemWidget(
          iconData: Icons.check,
          title: 'Menu Item Text',
          onTap: () => checkTap = true,
        )
    ));

    expect(checkTap, isFalse);
    final menuWidget = find.text('Menu Item Text');
    await tester.tap(menuWidget);
    await tester.pumpAndSettle();
    expect(checkTap, isTrue);
  });
}