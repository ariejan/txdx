
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../config/colors.dart';
import '../../input/browser.dart';
import '../../providers/items/item_notifier_provider.dart';
import '../../providers/items/selected_item_provider.dart';
import '../../txdx/txdx_item.dart';
import '../context/context_menu_area.dart';
import '../context/context_menu_item.dart';
import '../context/priority_button.dart';
import '../misc/pill_widget.dart';
import 'item_due_on_widget.dart';
import 'item_tag_widget.dart';

class ShowItemWidget extends ConsumerWidget {
  const ShowItemWidget(this.item, {Key? key}) : super(key: key);

  final TxDxItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

}