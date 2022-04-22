import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../config/colors.dart';
import '../../txdx/txdx_item.dart';

class PriorityButton extends StatelessWidget {

  final String label;
  final String? priority;
  final TxDxItem item;
  final GestureTapCallback onTap;

  const PriorityButton({
    Key? key,
    required this.label,
    this.priority,
    required this.item,
    required this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedPriority = item.priority == priority;
    final highlightColor = Theme.of(context).brightness == Brightness.dark
        ? TxDxColors.darkContextHoverColor
        : TxDxColors.lightContextHoverColor;

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: selectedPriority ? highlightColor : Colors.transparent,
      ),
      child: IconButton(
          icon: FaIcon(
              iconData,
              color: TxDxColors.forPriority(priority),
              size: 16),
          splashRadius: 1,
          hoverColor: highlightColor,
          onPressed: onTap,
      ),
    );
  }
}