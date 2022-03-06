import 'package:flutter/material.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:intl/intl.dart';
import 'package:txdx/widgets/pill_widget.dart';

class ItemDueOnWidget extends StatelessWidget {

  final DateTime dueOn;

  const ItemDueOnWidget(this.dueOn, {Key? key}) : super(key: key);

  Color _getBackgroundColor(BuildContext context, DateTime dueOn) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (dueOn == today) {
      return NordColors.aurora.green;
    } else if (dueOn.isBefore(today)) {
      return NordColors.aurora.red;
    } else {
      return NordColors.$9;
    }
  }

  @override
  Widget build(BuildContext context) {
    final fgColor = _getBackgroundColor(context, dueOn);

    return PillWidget(
      DateFormat.yMMMd().format(dueOn),
      color: fgColor,
    );
  }

}