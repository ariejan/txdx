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

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: selectedPriority ? Theme.of(context).highlightColor : null,
      ),
      child: TextButton(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.hovered)) {
                return Theme.of(context).hoverColor;
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