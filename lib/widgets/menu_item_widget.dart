import 'package:flutter/material.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/scoped_item_notifier.dart';

class MenuItemWidget extends ConsumerWidget {
  const MenuItemWidget({
    Key? key,
    this.icon,
    this.indicatorColor,
    required this.title,
    this.itemFilterValue,
    this.onTap,
    this.highlighted = false,
  }) : super(key: key);

  final Widget? icon;
  final Color? indicatorColor;
  final String title;
  final GestureTapCallback? onTap;
  final bool highlighted;

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
        bgColor = NordColors.polarNight.lighter;
        break;
      case Brightness.light:
        bgColor = NordColors.snowStorm.darkest;
        break;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _onTap,
        child: Container(
          color: highlighted() ? bgColor : Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(6, 3, 6, 3),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: icon ?? Container(
                    width: 16,
                    height: 16,
                    color: indicatorColor ?? Colors.blue,
                  )
                  ,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}