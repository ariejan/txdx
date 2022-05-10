import 'package:flutter/material.dart';

import '../../../config/colors.dart';
import '../../../txdx/txdx_item.dart';

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
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.all(8),
          child: Icon(
            Icons.circle_sharp,
            size: 9,
            color: TxDxColors.forPriority(priority),
          ),
        ),
      ),
    );
  }
}