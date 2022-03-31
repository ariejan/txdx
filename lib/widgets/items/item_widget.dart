import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:txdx/input/browser.dart';
import 'package:txdx/providers/items/item_notifier_provider.dart';
import 'package:txdx/providers/items/selected_item_provider.dart';
import 'package:txdx/widgets/context/context_menu_item.dart';
import 'package:txdx/widgets/misc/pill_widget.dart';

import '../../config/colors.dart';
import '../../txdx/txdx_item.dart';
import '../context/context_menu_area.dart';
import 'item_due_on_widget.dart';
import 'item_tag_widget.dart';
import '../context/priority_button.dart';

class ItemWidget extends ConsumerWidget {
  ItemWidget(this.item, {Key? key, this.onCompletedToggle})
      : super(key: key);

  final TxDxItem item;
  final ValueChanged<bool>? onCompletedToggle;

  final _focusNode = FocusNode();
  final _textController = TextEditingController();

  static const opacity = 0.5;

  Color _getRowColor(bool isSelected, bool isEditing) {
    if (isEditing) {
      return Colors.transparent;
    } else {
      return TxDxColors.forPriority(item.priority);
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
        ref.read(selectedItemIdStateProvider.state).state = item.id;
      },
      child: ContextMenuArea(
        verticalPadding: 8,
        items: [
          Padding(
            padding: const EdgeInsets.all(0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PriorityButton(
                  item: item,
                  priority: 'A',
                  iconData: FontAwesomeIcons.a,
                  onTap: () {
                    Navigator.of(context).pop();
                    ref.read(itemsNotifierProvider.notifier).setPriority(item.id, 'A');
                  }
                ),
                PriorityButton(
                    item: item,
                    priority: 'B',
                    iconData: FontAwesomeIcons.b,
                    onTap: () {
                      Navigator.of(context).pop();
                      ref.read(itemsNotifierProvider.notifier).setPriority(item.id, 'B');
                    }
                ),
                PriorityButton(
                    item: item,
                    priority: 'C',
                    iconData: FontAwesomeIcons.c,
                    onTap: () {
                      Navigator.of(context).pop();
                      ref.read(itemsNotifierProvider.notifier).setPriority(item.id, 'C');
                    }
                ),
                PriorityButton(
                    item: item,
                    priority: 'D',
                    iconData: FontAwesomeIcons.d,
                    onTap: () {
                      Navigator.of(context).pop();
                      ref.read(itemsNotifierProvider.notifier).setPriority(item.id, 'D');
                    }
                ),
                PriorityButton(
                    item: item,
                    priority: null,
                    iconData: FontAwesomeIcons.asterisk,
                    onTap: () {
                      Navigator.of(context).pop();
                      ref.read(itemsNotifierProvider.notifier).setPriority(item.id, null);
                    }
                ),
              ]
            ),
          ),
          ContextMenuItem(
            leading: const FaIcon(FontAwesomeIcons.check, size: 16),
            title: item.completed ? 'Mark as pending' : 'Mark as completed',
            onTap: () {
              Navigator.of(context).pop();
              ref.read(itemsNotifierProvider.notifier).toggleComplete(item.id);
            },
          ),
          const Divider(),
          ContextMenuItem(
            leading: const FaIcon(FontAwesomeIcons.calendarDay, size: 16),
            title: 'Move to today',
            onTap: () {
              Navigator.of(context).pop();
              ref.read(itemsNotifierProvider.notifier).moveToToday(item.id);
            },
          ),
          ContextMenuItem(
            leading: const FaIcon(FontAwesomeIcons.truckFast, size: 16),
            title: 'Postpone 7 days',
            onTap: () {
              Navigator.of(context).pop();
              ref.read(itemsNotifierProvider.notifier).postpone(item.id, 7);
            },
          ),
          const Divider(),
          ContextMenuItem(
            leading: const FaIcon(FontAwesomeIcons.trashCan, size: 16),
            title: 'Delete',
            onTap: () {
              Navigator.of(context).pop();
              ref.read(itemsNotifierProvider.notifier).deleteItem(item.id);
            },
          ),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Linkify(
                      text: item.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      onOpen: (LinkableElement link) {
                        launchInBrowser(link.url);
                      },
                      style: item.completed
                          ? TextStyle(
                            color: Theme.of(context).disabledColor,
                            decoration: TextDecoration.lineThrough,
                      )
                          : Theme.of(context).textTheme.bodyText2,
                      linkStyle: item.completed
                          ? TextStyle(
                        color: Theme.of(context).disabledColor,
                        decoration: TextDecoration.lineThrough,
                        height: 1,
                      )
                          : Theme.of(context).textTheme.bodyText2!.copyWith(
                        height: 1,
                        color: TxDxColors.linkText,
                      ),
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
                          color: TxDxColors.contexts,
                        )
                      ],
                      for (var project in item.projects) ...[
                        PillWidget(
                          project,
                          color: TxDxColors.projects,
                        )
                      ],
                      for (var key in item.tagsWithoutDue.keys) ...[
                        ItemTagWidget(
                          name: key,
                          value: item.tags[key],
                          color: TxDxColors.tags,
                        )
                      ],
                    ]
                )
            )
          ],
        ),
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
        return TxDxColors.checkboxHover;
      }
      return TxDxColors.checkbox;
    }

    var statusColor = _getRowColor(isSelected, isEditing);
    var bgColor = Colors.transparent;

    if (isSelected) {
      bgColor = Theme.of(context).hoverColor;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 1, 0, 1),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          border: Border(
            left: BorderSide(width: 5, color: statusColor),
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
                  splashRadius: 0,
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
