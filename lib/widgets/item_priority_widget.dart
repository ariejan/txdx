import 'package:flutter/material.dart';
import 'package:txdx/widgets/pill_widget.dart';

import '../theme/colors.dart';

class ItemPriorityWidget extends StatelessWidget {

  final String priority;

  const ItemPriorityWidget(
    this.priority, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PillWidget(
      priority,
      color: TxDxColors.forPriority(priority),
    );
  }
}