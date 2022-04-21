import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lit_relative_date_time/lit_relative_date_time.dart';
import 'package:txdx/providers/items/now_provider.dart';

import '../../config/colors.dart';

class ItemDueOnWidget extends ConsumerWidget {

  final DateTime dueOn;

  const ItemDueOnWidget(this.dueOn, {Key? key}) : super(key: key);

  Color _getBackgroundColor(BuildContext context, DateTime dueOn) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (dueOn == today) {
      return TxDxColors.dueOnToday;
    } else if (dueOn.isBefore(today)) {
      return TxDxColors.dueOnOverdue;
    } else {
      return TxDxColors.dueOn;
    }
  }

  Widget _justText(String text, Color color) {
    return Tooltip(
      message: DateFormat.yMMMd().format(dueOn),
      preferBelow: false,
      child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: color,
          )
      ),
    );
  }

  Widget _renderDueOn(BuildContext context, DateTime now, Color color) {
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    if (dueOn == today) {
      return _justText('today', color);
    } else if (dueOn == tomorrow) {
      return _justText('tomorrow', color);
    } else if (dueOn == yesterday) {
      return _justText('yesterday', color);
    } else {
      final _formatter = RelativeDateFormat(
        Localizations.localeOf(context)
      );
      final _relDateTime = RelativeDateTime(
        dateTime: today,
        other: dueOn,
      );
      return _justText(_formatter.format(_relDateTime), color);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final datetime = ref.watch(timeProvider);
    final fgColor = _getBackgroundColor(context, dueOn);

    return Container(
      padding: const EdgeInsets.fromLTRB(2, 3, 2, 3),
      margin: const EdgeInsets.fromLTRB(2, 0, 2, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
      ),
      child: _renderDueOn(context, datetime, fgColor)
    );
  }
}