import 'package:flutter/material.dart';
import 'package:txdx/widgets/pill_widget.dart';

class ItemPriorityWidget extends StatelessWidget {

  final String priority;

  const ItemPriorityWidget(
    this.priority, {Key? key}) : super(key: key);

  static const priorityColours = {
    'A': Colors.red,
    'B': Colors.orange,
    'C': Colors.yellow,
    'D': Colors.green,
  };

  @override
  Widget build(BuildContext context) {
    return PillWidget(
      priority,
      color: priorityColours[priority] ?? Colors.green,
    );
  }
}