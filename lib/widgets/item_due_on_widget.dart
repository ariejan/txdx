import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:txdx/widgets/pill_widget.dart';

class ItemDueOnWidget extends StatelessWidget {

  final DateTime dueOn;

  const ItemDueOnWidget(this.dueOn, {Key? key}) : super(key: key);

  Color _getBackgroundColor(DateTime dueOn) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    if (dueOn == today) {
      return Colors.green;
    } else if (dueOn == tomorrow) {
      return Colors.yellow;
    } else if (dueOn.isBefore(today)) {
      return Colors.red;
    } else {
      return Colors.white38;
    }
  }

  @override
  Widget build(BuildContext context) {
    final fgColor = _getBackgroundColor(dueOn);

    return PillWidget(
      DateFormat.yMMMd().format(dueOn),
      color: fgColor,
    );
  }

}