
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/widgets/misc/label_widget.dart';

import '../../config/colors.dart';
import '../../utils/browser.dart';
import '../../providers/items/item_notifier_provider.dart';
import '../../providers/items/selected_item_provider.dart';
import '../../txdx/txdx_item.dart';
import '../context/context_menu_area.dart';
import '../context/context_menu_item.dart';
import '../context/priority_button.dart';
import 'item_due_on_widget.dart';

class ShowItemWidget extends ConsumerWidget {
  const ShowItemWidget(this.item, {Key? key}) : super(key: key);

  final TxDxItem item;

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
        return Theme.of(context).brightness == Brightness.light
            ? TxDxColors.lightCheckboxHover
            : TxDxColors.darkCheckboxHover;
      }
      return Theme.of(context).brightness == Brightness.light
          ? TxDxColors.lightCheckbox
          : TxDxColors.darkCheckbox;
    }

    var statusColor = TxDxColors.forPriority(item.priority);
    var bgColor = Colors.transparent;

    if (isSelected) {
      bgColor = Theme.of(context).highlightColor;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Icon(
                  Icons.circle,
                  size: 9,
                  color: item.hasSetPriority() ? statusColor : Colors.transparent,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                child: Transform.scale(
                  scale: 0.76,
                  child: Checkbox(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      fillColor: MaterialStateProperty.resolveWith(getColor),
                      tristate: false,
                      splashRadius: 0,
                      value: item.completed,
                      onChanged: (bool? value) {
                        ref.read(editingItemIdStateProvider.state).state = null;
                        ref.read(itemsNotifierProvider.notifier).toggleComplete(item.id);
                      }),
                ),
              ),
              Expanded(
                child: GestureDetector(
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
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              PriorityButton(
                                  item: item,
                                  priority: 'A',
                                  label: 'A',
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    ref.read(itemsNotifierProvider.notifier).setPriority(item.id, 'A');
                                  }
                              ),
                              PriorityButton(
                                  item: item,
                                  priority: 'B',
                                  label: 'B',
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    ref.read(itemsNotifierProvider.notifier).setPriority(item.id, 'B');
                                  }
                              ),
                              PriorityButton(
                                  item: item,
                                  priority: 'C',
                                  label: 'C',
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    ref.read(itemsNotifierProvider.notifier).setPriority(item.id, 'C');
                                  }
                              ),
                              PriorityButton(
                                  item: item,
                                  priority: 'D',
                                  label: 'D',
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    ref.read(itemsNotifierProvider.notifier).setPriority(item.id, 'D');
                                  }
                              ),
                              PriorityButton(
                                  item: item,
                                  priority: null,
                                  label: 'X',
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    ref.read(itemsNotifierProvider.notifier).setPriority(item.id, null);
                                  }
                              ),
                            ]
                        ),
                      ),
                      ContextMenuItem(
                        leading: const Icon(Icons.check, size: 16),
                        title: item.completed ? 'Mark as pending' : 'Mark as completed',
                        onTap: () {
                          Navigator.of(context).pop();
                          ref.read(itemsNotifierProvider.notifier).toggleComplete(item.id);
                        },
                      ),
                      const Divider(),
                      ContextMenuItem(
                        leading: const Icon(Icons.today_sharp, size: 16),
                        title: 'Move to today',
                        onTap: () {
                          Navigator.of(context).pop();
                          ref.read(itemsNotifierProvider.notifier).moveToToday(item.id);
                        },
                      ),
                      ContextMenuItem(
                        leading: const Icon(Icons.update_sharp, size: 16),
                        title: 'Postpone 7 days',
                        onTap: () {
                          Navigator.of(context).pop();
                          ref.read(itemsNotifierProvider.notifier).postpone(item.id, 7);
                        },
                      ),
                      const Divider(),
                      ContextMenuItem(
                        leading: const Icon(Icons.delete_forever_sharp, size: 16),
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
                          padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
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
                                    LabelWidget(
                                      context,
                                      color: TxDxColors.contexts,
                                      iconData: Icons.label_sharp,
                                    ),
                                  ],
                                  for (var project in item.projects) ...[
                                    LabelWidget(project, color: TxDxColors.projects, iconData: Icons.label_sharp),
                                  ],
                                  for (var key in item.tagsWithoutDue.keys) ...[
                                    LabelWidget('$key:${item.tags[key]}', color: TxDxColors.tags),
                                  ],
                                ]
                            )
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
        ),
      ),
    );
  }

}