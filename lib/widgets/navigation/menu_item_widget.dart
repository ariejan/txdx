import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/widgets/misc/pill_widget.dart';

import '../../providers/items/scoped_item_notifier.dart';
import '../../config/colors.dart';

class MenuItemWidget extends ConsumerWidget {
  const MenuItemWidget({
    Key? key,
    this.icon,
    this.indicatorColor,
    required this.title,
    this.itemFilterValue,
    this.onTap,
    this.color,
    this.highlighted = false,
    this.badgeCount,
    this.badgeColor,
  }) : super(key: key);

  final Widget? icon;
  final Color? indicatorColor;
  final Color? color;
  final String title;
  final GestureTapCallback? onTap;
  final bool highlighted;

  final int? badgeCount;
  final Color? badgeColor;

  final String? itemFilterValue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    void _onTap() {
      if (onTap != null) {
        onTap!.call();
      } else {
        ref.read(itemFilter.state).state = itemFilterValue;
      }
    }

    bool highlighted() {
      return ref.watch(itemFilter.state).state == itemFilterValue;
    }

    var bgColor = Colors.transparent;

    switch(Theme.of(context).brightness) {
      case Brightness.dark:
        bgColor = TxDxColors.darkSelection;
        break;
      case Brightness.light:
        bgColor = TxDxColors.lightSelection;
        break;
    }

    return Container(
      color: highlighted() ? bgColor : null,
      child: ListTile(
        onTap: _onTap,

        leading: icon ?? Icon(Icons.circle, size: 16),
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: color,
          ),
        ),
        trailing: (badgeCount != null && badgeCount! > 0)
        ? PillWidget(
            "$badgeCount",
            fontSize: 11,
            backgroundColor: badgeColor ?? TxDxColors.prioDefault,
        ) : null,
      ),
    );
  }
}