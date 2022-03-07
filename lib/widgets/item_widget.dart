import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:txdx/providers/item_notifier_provider.dart';
import 'package:txdx/providers/selected_item_provider.dart';
import 'package:txdx/widgets/pill_widget.dart';

import '../txdx/txdx_item.dart';
import 'item_due_on_widget.dart';
import 'item_tag_widget.dart';

class ItemWidget extends ConsumerWidget {
  ItemWidget(this.item, {Key? key, this.onCompletedToggle})
      : super(key: key);

  final TxDxItem item;
  final ValueChanged<bool>? onCompletedToggle;

  final _focusNode = FocusNode();
  final _textController = TextEditingController();

  static const opacity = 0.5;

  static final priorityColours = {
    'A': NordColors.aurora.red,
    'B': NordColors.aurora.orange,
    'C': NordColors.aurora.yellow,
    'D': NordColors.aurora.green,
  };

  Color _getRowColor(bool isSelected, bool isEditing) {
    if (isEditing) {
      return Colors.transparent;
    } else {
      return priorityColours[item.priority] ?? Colors.transparent;
    }
  }

  Widget _editItem(BuildContext context, WidgetRef ref) {
    _focusNode.requestFocus();

    _textController.text = item.toString();

    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
            child: Row(
              children: [
                Expanded(
                  child: Focus(
                    onKey: (FocusNode node, RawKeyEvent event) {
                      if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
                        ref.read(itemsNotifierProvider.notifier).updateItem(item.id, _textController.text);
                        ref.read(editingItemIdStateProvider.state).state = null;
                        return KeyEventResult.handled;
                      }
                      return KeyEventResult.ignored;
                    },
                    child: TextFormField(
                      focusNode: _focusNode,
                      controller: _textController,
                    ),
                  ),
                ),
                IconButton(
                  icon: const FaIcon(
                    FontAwesomeIcons.trash,
                    size: 16,
                  ),
                  color: Theme.of(context).errorColor,
                  onPressed: () {
                    ref.read(editingItemIdStateProvider.state).state = null;
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
        ref.read(editingItemIdStateProvider.state).state = item.id;
      },
      onTap: () {
        ref.read(editingItemIdStateProvider.state).state = item.id;
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
    final editingItemId = ref.watch(editingItemIdStateProvider);
    final isEditing = editingItemId != null && editingItemId == item.id;

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

    Color rowColor = _getRowColor(isSelected, isEditing);

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 1, 0, 1),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? NordColors.snowStorm.medium : Colors.transparent,
          border: Border(
            left: BorderSide(width: 5, color: rowColor),
          ),
        ),
        child: Row(
          crossAxisAlignment: isEditing ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
              child: Checkbox(
                  shape: const CircleBorder(),
                  fillColor: MaterialStateProperty.resolveWith(getColor),
                  tristate: false,
                  value: item.completed,
                  onChanged: (bool? value) {
                    ref.read(editingItemIdStateProvider.state).state = null;
                    onCompletedToggle!(value ?? false);
                  }),
            ),
            Expanded(
              child: isEditing ? _editItem(context, ref) : _displayItem(context, ref),
            )
          ]
        ),
      ),
    );
  }
}
