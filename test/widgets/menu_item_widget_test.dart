
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:txdx/widgets/menu_item_widget.dart';

import 'test_helpers.dart';

void main() {

  testWidgets('shows menu item title', (tester) async {
    await tester.pumpWidget(await TestHelpers.wrapWidget(
      const MenuItemWidget(
          icon: FaIcon(FontAwesomeIcons.check),
          title: 'Menu Item Text',
      ),
    ));

    final textWidget = find.text("Menu Item Text");
    expect(textWidget, findsOneWidget);
  });

  testWidgets('shows menu icon', (tester) async {
    await tester.pumpWidget(await TestHelpers.wrapWidget(
        const MenuItemWidget(
          icon: FaIcon(FontAwesomeIcons.check),
          title: 'Menu Item Text',
        )
    ));

    final iconWidget = find.byType(FaIcon);
    expect(iconWidget, findsOneWidget);
  });

  testWidgets('handles on tap events', (tester) async {
    var checkTap = false;

    await tester.pumpWidget(await TestHelpers.wrapWidget(
        MenuItemWidget(
          icon: const FaIcon(FontAwesomeIcons.check),
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