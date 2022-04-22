import 'package:flutter/material.dart';

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
      child: TextButton(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.hovered)) {
                return Theme.of(context).disabledColor;
              }
              return null; // Defer to the widget's default.
            },
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: TxDxColors.forPriority(priority),
          ),
        ),
        onPressed: onTap,
      ),
    );
  }
}