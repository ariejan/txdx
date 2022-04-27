import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/utils/focus.dart';
import 'package:txdx/widgets/misc/pill_widget.dart';

import '../../providers/items/scoped_item_notifier.dart';
import '../../config/colors.dart';

class MenuItemWidget extends ConsumerWidget {
  const MenuItemWidget({
    Key? key,
    this.iconData,
    this.indicatorColor,
    required this.title,
    this.itemFilterValue,
    this.onTap,
    this.color,
    this.highlighted = false,
    this.badgeCount,
    this.badgeColor,
  }) : super(key: key);

  final IconData? iconData;
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
        ref.read(searchTextProvider.state).state = null;
        ref.read(isSearchingProvider.state).state = false;
        appFocusNode.requestFocus();
      }
    }

    bool highlighted() {
      return ref.watch(itemFilter.state).state == itemFilterValue;
    }

    return Container(
      decoration: BoxDecoration(
        color: highlighted() ? Theme.of(context).highlightColor : Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(8),
      ),

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: GestureDetector(
          onTap: _onTap,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildIcon(context),
              const SizedBox(width: 6),
              buildTitle(),
              buildBadge(context),
            ]
          ),
        ),
      ),
    );
  }

  Widget buildTitle() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 1),
        child: SizedBox(
            height: 18,
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                color: color,
              ),
            ),
          ),
      ),
    );
  }

  Widget buildIcon(BuildContext context) {
    return Icon(
      iconData ??  Icons.circle,
      color: (indicatorColor ?? color) ?? Theme.of(context).textTheme.bodyText1?.color,
      size: 20
    );
  }

  Widget buildBadge(BuildContext context) {
    return SizedBox(
      width: 40,
      child: (badgeCount == null || badgeCount! <= 0)
        ? Container()
        : SizedBox(
          child: PillWidget(
            "$badgeCount",
            fontSize: 11,
            backgroundColor: badgeColor ?? TxDxColors.prioDefault,
            color: Theme.of(context).textTheme.bodyText1?.color,
          ),
        ),
    );
  }
}