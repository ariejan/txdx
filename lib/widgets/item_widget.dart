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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
          child: Checkbox(
              shape: const CircleBorder(),
              value: item.completed,
              onChanged: (bool? value) {
                onCompletedToggle!(value ?? false);
              }),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Text(
                  item.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                child: Row(
                  children: [
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
                  ]
                )
              )
            ],
          ),
        )
      ]
    );
  }
}
