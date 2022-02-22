import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/widgets/pill_widget.dart';

import '../txdx/txdx_item.dart';

class ItemWidget extends ConsumerWidget {
  const ItemWidget(this.item, {Key? key, this.onCompletedToggle})
      : super(key: key);

  final TxDxItem item;
  final ValueChanged<bool>? onCompletedToggle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return
      SizedBox(
        height: 50,
        child: Row(
          children: [
            Checkbox(
                shape: const CircleBorder(),
                value: item.completed,
                onChanged: (bool? value) {
                  onCompletedToggle!(value ?? false);
                }),
            SizedBox(
              width: 16,
              child: Text(
                item.priority ?? '',
                textAlign: TextAlign.center,
              )
            ),
            SizedBox(
              child: Text(
                item.description,
                textAlign: TextAlign.left,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            for (var context in item.contexts) ...[
              PillWidget(
                context,
                color: Colors.teal,
              )
            ],
            for (var project in item.projects) ...[
              PillWidget(
                project,
                color: Colors.orange,
              )
            ],
          ],
        ),
      );
  }
}
