import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/widgets/item_priority_widget.dart';
import 'package:txdx/widgets/pill_widget.dart';

import '../txdx/txdx_item.dart';
import 'item_due_on_widget.dart';
import 'item_tag_widget.dart';

class ItemWidget extends ConsumerWidget {
  const ItemWidget(this.item, {Key? key, this.onCompletedToggle})
      : super(key: key);

  final TxDxItem item;
  final ValueChanged<bool>? onCompletedToggle;

  static final priorityColours = {
    'A': Colors.red.withOpacity(0.1),
    'B': Colors.orange.withOpacity(0.1),
    'C': Colors.yellow.withOpacity(0.1),
    'D': Colors.green.withOpacity(0.1),
  };

  Color _getRowColor() {
    if (item.completed) {
      return Colors.blue.withOpacity(0.1);
    } else {
      return priorityColours[item.priority] ?? Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: _getRowColor(),
      child: Row(
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (item.priority != null)
                        ItemPriorityWidget(item.priority!),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                  child: Row(
                    children: [
                      if (item.dueOn != null)
                        ItemDueOnWidget(item.dueOn!),
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
                      for (var key in item.tags.keys) ...[
                        ItemTagWidget(
                          name: key,
                          value: item.tags[key],
                        )
                      ],
                    ]
                  )
                )
              ],
            ),
          )
        ]
      ),
    );
  }
}
