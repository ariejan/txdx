import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/utils/date_helper.dart';
import 'package:txdx/widgets/common/items/label_widget.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../config/colors.dart';
import '../../../config/shortcuts.dart';
import '../../../providers/items/item_notifier_provider.dart';
import '../../../providers/items/selected_item_provider.dart';
import '../../../txdx/txdx_item.dart';
import '../../common/items/priority_dot.dart';
import '../context/context_menu_area.dart';
import '../context/context_menu_item.dart';
import '../context/priority_button.dart';
import '../../common/items/due_on_widget.dart';

class ShowItemWidget extends ConsumerWidget {
  const ShowItemWidget(this.item, {this.archiveView = false, Key? key})
      : super(key: key);

  final TxDxItem item;
  final bool archiveView;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedItemId = ref.watch(selectedItemIdStateProvider);
    final isSelected = selectedItemId != null && selectedItemId == item.id;
    final contextHighlightedId = ref.watch(contextMenuItemIdStateProvider);
    final isContextHighlighted = contextHighlightedId != null && contextHighlightedId == item.id;

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

    var bgColor = Colors.transparent;

    if (isSelected) {
      bgColor = Theme.of(context).highlightColor;
    }

    final isShowingMetadata = (item.projects.isNotEmpty ||
        item.contexts.isNotEmpty ||
        item.tagsWithoutDue.isNotEmpty);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isContextHighlighted ? Theme.of(context).highlightColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 3, 12, 3),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PriorityDot(item),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                child: Column(
                  children: [
                    if (!archiveView)
                      Transform.scale(
                        scale: 0.76,
                        child: Checkbox(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                            fillColor:
                                MaterialStateProperty.resolveWith(getColor),
                            tristate: false,
                            splashRadius: 0,
                            value: item.completed,
                            onChanged: archiveView
                                ? null
                                : (bool? value) {
                                    ref
                                        .read(editingItemIdStateProvider.state)
                                        .state = null;
                                    ref
                                        .read(todoItemsProvider.notifier)
                                        .toggleComplete(item.id);
                                  }),
                      ),
                    if (archiveView)
                      IconButton(
                        mouseCursor: MouseCursor.defer,
                        onPressed: () {
                          Actions.maybeInvoke(
                              context, UnarchiveItemIntent(item.id));
                        },
                        padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        icon: Icon(
                          Icons.settings_backup_restore_sharp,
                          size: 16,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onDoubleTap: () {
                    ref.read(selectedItemIdStateProvider.state).state = item.id;
                    ref.read(editingItemIdStateProvider.state).state = item.id;
                  },
                  onTap: () {
                    ref.read(selectedItemIdStateProvider.state).state = item.id;
                  },
                  child: ContextMenuArea(
                    verticalPadding: 8,
                    onHighlight: () => ref.read(contextMenuItemIdStateProvider.state).state = item.id,
                    onDismiss: () => ref.read(contextMenuItemIdStateProvider.state).state = null,
                    items: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              PriorityButton(
                                  item: item,
                                  priority: 'A',
                                  label: 'A',
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    ref
                                        .read(todoItemsProvider.notifier)
                                        .setPriority(item.id, 'A');
                                  }),
                              PriorityButton(
                                  item: item,
                                  priority: 'B',
                                  label: 'B',
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    ref
                                        .read(todoItemsProvider.notifier)
                                        .setPriority(item.id, 'B');
                                  }),
                              PriorityButton(
                                  item: item,
                                  priority: 'C',
                                  label: 'C',
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    ref
                                        .read(todoItemsProvider.notifier)
                                        .setPriority(item.id, 'C');
                                  }),
                              PriorityButton(
                                  item: item,
                                  priority: 'D',
                                  label: 'D',
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    ref
                                        .read(todoItemsProvider.notifier)
                                        .setPriority(item.id, 'D');
                                  }),
                              PriorityButton(
                                  item: item,
                                  priority: null,
                                  label: 'X',
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    ref
                                        .read(todoItemsProvider.notifier)
                                        .setPriority(item.id, null);
                                  }),
                            ]),
                      ),
                      ContextMenuItem(
                        leading: const Icon(Icons.edit, size: 16),
                        title: 'Edit...',
                        onTap: () {
                          Navigator.of(context).pop();
                          ref.read(selectedItemIdStateProvider.state).state = item.id;
                          ref.read(editingItemIdStateProvider.state).state = item.id;
                        },
                      ),
                      ContextMenuItem(
                        leading: const Icon(Icons.check, size: 16),
                        title: item.completed
                            ? 'Mark as pending'
                            : 'Mark as completed',
                        onTap: () {
                          Navigator.of(context).pop();
                          ref
                              .read(todoItemsProvider.notifier)
                              .toggleComplete(item.id);
                        },
                      ),
                      const Divider(),
                      ContextMenuItem(
                        leading: const Icon(Icons.today_sharp, size: 16),
                        title: 'Move to today',
                        onTap: () {
                          Navigator.of(context).pop();
                          ref
                              .read(todoItemsProvider.notifier)
                              .moveToToday(item.id);
                        },
                      ),
                      ContextMenuItem(
                        leading: const Icon(Icons.update_sharp, size: 16),
                        title: 'Postpone to next week',
                        onTap: () {
                          Navigator.of(context).pop();
                          ref
                              .read(todoItemsProvider.notifier)
                              .setDueOn(item.id, DateHelper.futureWeekDate(DateTime.monday));
                        },
                      ),
                      const Divider(),
                      ContextMenuItem(
                        leading:
                            const Icon(Icons.delete_forever_sharp, size: 16),
                        title: 'Delete',
                        onTap: () {
                          Navigator.of(context).pop();
                          ref
                              .read(todoItemsProvider.notifier)
                              .deleteItem(item.id);
                        },
                      ),
                    ],
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      0, isShowingMetadata ? 2 : 0, 0, 0),
                                  child: MarkdownBody(
                                    data: item.description,
                                    onTapLink: (_, href, __) {
                                      launchUrlString(href!);
                                    }
                                  ),
                                ),
                                if (!item.completed && isShowingMetadata)
                                  Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 2, 0, 4),
                                      child: Wrap(
                                          alignment: WrapAlignment.start,
                                          spacing: 2,
                                          crossAxisAlignment: WrapCrossAlignment.center,
                                          children: [
                                            for (var project in item.projects) ...[
                                              LabelWidget(project,
                                                  color: TxDxColors.projects,
                                                  iconData: Icons.label_sharp),
                                            ],
                                            for (var context in item.contexts) ...[
                                              LabelWidget(context,
                                                  color: TxDxColors.contexts,
                                                  iconData: Icons.label_sharp),
                                            ],
                                            for (var key
                                                in item.tagsWithoutDue.keys) ...[
                                              LabelWidget('$key:${item.tags[key]}',
                                                  color: TxDxColors.tags,
                                                  iconData: Icons.label_sharp),
                                            ],
                                          ]))
                              ],
                            ),
                          ),
                          if (!item.completed && item.hasDueOn)
                            DueOnWidget(item.dueOn!),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
