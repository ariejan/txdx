import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:txdx/providers/item_notifier_provider.dart';
import 'package:txdx/providers/selected_item_provider.dart';
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

  Color _getRowColor(bool isSelected) {
    if (item.completed) {
      return Colors.blue.withOpacity(0.1);
    } else if (isSelected) {
      return Colors.blueGrey.withOpacity(0.5);
    } else {
      return priorityColours[item.priority] ?? Colors.transparent;
    }
  }

  Widget _editItem(BuildContext context, WidgetRef ref) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: item.toString(),
                    onFieldSubmitted: (value) {
                      ref.read(selectedItemIdStateProvider.state).state = null;
                      ref.read(itemsNotifierProvider.notifier).updateItem(item.id, value);
                    }
                  ),
                ),
                IconButton(
                  icon: const FaIcon(
                    FontAwesomeIcons.trash,
                    size: 16,
                  ),
                  color: Theme.of(context).errorColor,
                  onPressed: () {
                    ref.read(selectedItemIdStateProvider.state).state = null;
                    ref.read(itemsNotifierProvider.notifier).deleteItem(item.id);
                  },
                ),
              ],
            ),
          ),
        ]
      ),
    );
  }

  Widget _displayItem(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onDoubleTap: () {
        ref.read(selectedItemIdStateProvider.state).state = item.id;
      },
      onTap: () {
        ref.read(selectedItemIdStateProvider.state).state = item.id;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                    children: [
                      if (item.dueOn != null)
                        ItemDueOnWidget(item.dueOn!),
                      if (item.priority != null)
                        ItemPriorityWidget(item.priority!),
                    ]
                )
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
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
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedItemId = ref.watch(selectedItemIdStateProvider);
    final isSelected = selectedItemId != null && selectedItemId == item.id;

    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Theme.of(context).hoverColor;
      }
      return Theme.of(context).primaryColor;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 1, 0, 1),
      child: Container(
        color: _getRowColor(isSelected),
        child: Row(
          crossAxisAlignment: isSelected ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
              child: Checkbox(
                  shape: const CircleBorder(),
                  fillColor: MaterialStateProperty.resolveWith(getColor),
                  tristate: false,
                  value: item.completed,
                  onChanged: (bool? value) {
                    ref.read(selectedItemIdStateProvider.state).state = null;
                    onCompletedToggle!(value ?? false);
                  }),
            ),
            Expanded(
              child: isSelected ? _editItem(context, ref) : _displayItem(context, ref),
            )
          ]
        ),
      ),
    );
  }
}
