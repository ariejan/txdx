import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jiffy/jiffy.dart';

import '../txdx/txdx_item.dart';

class DueNotificationWidget extends StatefulWidget {
  const DueNotificationWidget(this.item, {Key? key})
      : super(key: key);

  final TxDxItem item;

  @override
  State<DueNotificationWidget> createState() => _DueNotificationWidgetState();
}

class _DueNotificationWidgetState extends State<DueNotificationWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.item.hasDueOn) {
      return
        Container(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Tooltip(
              message: 'Due: ' + Jiffy(widget.item.dueOn).format('yyyy-MM-dd'),
              preferBelow: false,
              child: const FaIcon(
                FontAwesomeIcons.clock,
                size: 18,
                color: Colors.indigo,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.indigo),
            )
        );
    } else {
      return const SizedBox.shrink();
    }
  }
}