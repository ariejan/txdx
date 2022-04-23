import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lit_relative_date_time/lit_relative_date_time.dart';
import 'package:txdx/providers/items/now_provider.dart';

import '../../config/colors.dart';

class ItemDueOnWidget extends ConsumerWidget {

  final DateTime dueOn;

  const ItemDueOnWidget(this.dueOn, {Key? key}) : super(key: key);

  Color? _getBackgroundColor(BuildContext context, DateTime now, DateTime dueOn) {
    if (dueOn.isBefore(now) || dueOn == now) {
      return TxDxColors.dueOnToday;
    } else {
      return Theme.of(context).disabledColor;
    }
  }

  Widget _justText(BuildContext context, String text, Color? color) {
    return Tooltip(
      message: DateFormat.yMMMd().format(dueOn),
      preferBelow: false,
      child: Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 12,
          )
      ),
    );
  }

  int _daysAhead(DateTime now, DateTime dueOn) {
    final difference = dueOn.difference(now);
    return difference.inDays;
  }

  Widget _renderDueOn(BuildContext context, DateTime now, Color? color) {
    final daysAhead = _daysAhead(now, dueOn);

    switch (daysAhead) {
      case -1:
        return _justText(context, 'Yesterday', color);
      case 0:
        return _justText(context, 'Today', color);
      case 1:
        return _justText(context, 'Tomorrow', color);
      case 2:
      case 3:
      case 4:
      case 5:
      case 6:
        final formatter = DateFormat(DateFormat.WEEKDAY);
        return _justText(context, formatter.format(dueOn), color);
      default:
        if (daysAhead > 0) {
          final _formatter = RelativeDateFormat(
              Localizations.localeOf(context)
          );
          final _relDateTime = RelativeDateTime(
            dateTime: now,
            other: dueOn,
          );
          return _justText(context, _formatter.format(_relDateTime), color);
        } else {
          return _justText(context, "Overdue", color);
        }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theTime = ref.watch(timeProvider);
    final now = DateTime(theTime.year, theTime.month, theTime.day);

    final fgColor = _getBackgroundColor(context, now, dueOn);

    return Container(
      padding: const EdgeInsets.fromLTRB(2, 3, 2, 3),
      margin: const EdgeInsets.fromLTRB(2, 0, 2, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(Icons.flag_sharp, size: 12, color: fgColor),
          const SizedBox(width: 4),
          _renderDueOn(context, now, fgColor),
        ],
      )
    );
  }
}