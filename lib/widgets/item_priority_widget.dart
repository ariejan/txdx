import 'package:flutter/material.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:txdx/widgets/pill_widget.dart';

class ItemPriorityWidget extends StatelessWidget {

  final String priority;

  const ItemPriorityWidget(
    this.priority, {Key? key}) : super(key: key);

  static final priorityColours = {
    'A': NordColors.aurora.red,
    'B': NordColors.aurora.orange,
    'C': NordColors.aurora.yellow,
    'D': NordColors.aurora.green,
  };

  @override
  Widget build(BuildContext context) {
    return PillWidget(
      priority,
      color: priorityColours[priority] ?? Colors.green,
    );
  }
}