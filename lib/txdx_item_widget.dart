import 'package:flutter/material.dart';

import 'due_notification_widget.dart';
import 'txdx/txdx.dart';

class TxDxItemWidget extends StatefulWidget {
  const TxDxItemWidget(this.item, {Key? key, this.onCompletedToggle})
      : super(key: key);

  final TxDxItem item;
  final ValueChanged<bool>? onCompletedToggle;

  @override
  State<StatefulWidget> createState() => _TxDxItemWidgetState();
}

class _TxDxItemWidgetState extends State<TxDxItemWidget> {
  @override
  Widget build(BuildContext context) {
    return
      SizedBox(
        height: 50,
        child: Row(
          children: [
            Checkbox(
                checkColor: Colors.white,
                fillColor:
                MaterialStateProperty.resolveWith(getColor),
                shape: const CircleBorder(),
                value: widget.item.completed,
                onChanged: (bool? value) {
                  widget.onCompletedToggle!(value ?? false);
                }),
            SizedBox(
              child: Text(
                widget.item.description,
                textAlign: TextAlign.left,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DueNotificationWidget(widget.item),
          ],
        ),
      );
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.deepOrange;
    }
    return Colors.brown;
  }

}