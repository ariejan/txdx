import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:txdx/config/icons.dart';
import 'package:txdx/providers/items/scoped_item_notifier.dart';
import 'package:txdx/providers/settings/settings_provider.dart';
import 'package:txdx/config/settings.dart';
import 'package:txdx/widgets/desktop/misc/search_widget.dart';

import '../../../config/colors.dart';
import '../../../config/filters.dart';
import '../../../config/shortcuts.dart';
import '../../../providers/files/file_change_provider.dart';
import '../../../providers/files/file_notifier_provider.dart';
import '../misc/file_changed_widget.dart';
import 'item_widget.dart';
import '../navigation/menu_header_widget.dart';

class ItemsListView extends ConsumerWidget {
  static ItemScrollController controller = ItemScrollController();

  const ItemsListView({Key? key}) : super(key: key);

  String _getTitle(WidgetRef ref) {
    final filter = ref.read(itemFilter);
    final upcomingDays = ref.read(interfaceSettingsProvider).getInt(settingsUpcomingDays);

    switch (filter) {
      case null:
      case filterAll:
        return 'Everything';
      case filterToday:
        return 'Today';
      case filterUpcoming:
        return 'Next $upcomingDays days';
      case filterSomeday:
        return 'Someday';
      case filterOverdue:
        return 'Overdue';
      default:
        return filter!;
    }
  }

  IconData _getIconData(WidgetRef ref) {
    final filter = ref.read(itemFilter);

    switch (filter) {
      case filterAll:
      case filterToday:
      case filterUpcoming:
      case filterSomeday:
      case filterOverdue:
        return txdxIconData[filter]!;
      default:
        return txdxIconData['project']!;
    }
  }

  Color? _getIconColor(WidgetRef ref) {
    final filter = ref.read(itemFilter);

    if (filter == null) {
      return null;
    }

    if (filter.substring(0, 1) == '+') {
      return TxDxColors.projects;
    }
    if (filter.substring(0, 1) == '@') {
      return TxDxColors.contexts;
    }

    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasFileChanges = ref.watch(todoFileWasChanged);
    final items = ref.watch(filteredItems);
    final isSearching = ref.watch(isSearchingProvider);

    final archiveAvailable = ref.watch(archivingAvailableProvider);

    var countString = "No items";
    switch (items.length) {
      case 1:
        countString = "1 item";
        break;
      default:
        countString = "${items.length} items";
    }

    return Column(
      children: [
        SizedBox(
          child: Column(
            children: [
              MenuHeaderWidget(
                _getTitle(ref),
                subtitle: countString,
                iconData: _getIconData(ref),
                iconColor: _getIconColor(ref),
                margin: const EdgeInsets.fromLTRB(0, 24, 0, 32),
                actions: [
                  if (archiveAvailable) IconButton(
                    mouseCursor: MouseCursor.defer,
                    icon: Icon(Icons.archive_outlined, size: 20, color: Theme.of(context).disabledColor),
                    tooltip: "Archive completed items to archive.txt",
                    onPressed: () {
                      Actions.invoke(context, ArchiveItemsIntent());
                    },
                  ),
                  IconButton(
                    mouseCursor: MouseCursor.defer,
                    icon: Icon(Icons.add, size: 20, color: Theme.of(context).disabledColor),
                    tooltip: 'Create a new item',
                    onPressed: () {
                      Actions.invoke(context, AddIntent());
                    },
                  ),
                  PopupMenuButton(
                    padding: EdgeInsets.zero,
                    splashRadius: 14,
                    icon: Icon(Icons.sort_sharp, size: 20, color: Theme.of(context).disabledColor),
                    color: Theme.of(context).brightness == Brightness.dark
                        ? TxDxColors.darkBadge2 : TxDxColors.lightBadge,
                    tooltip: "Change item sorting",
                    onSelected: (ItemStateSorter selectedItemStateSorter) {
                      ref.read(itemSortingPreferenceProvider.state).state = selectedItemStateSorter;
                    },
                    itemBuilder: (context) {
                      return [
                        CheckedPopupMenuItem<ItemStateSorter>(
                          padding: EdgeInsets.zero,
                          value: ItemStateSorter.priority,
                          checked: ref.watch(itemSortingPreferenceProvider) == ItemStateSorter.priority,
                          child: const ListTile(
                            title: Text('Sort by priority', style: TextStyle(fontSize: 12)),
                          )
                        ),
                        CheckedPopupMenuItem<ItemStateSorter>(
                          padding: EdgeInsets.zero,
                          value: ItemStateSorter.dueOn,
                          checked: ref.watch(itemSortingPreferenceProvider) == ItemStateSorter.dueOn,
                          child: const ListTile(
                            title: Text('Sort by due date', style: TextStyle(fontSize: 12)),
                          )
                        ),
                      ];
                    }
                  ),
                ],
              ),
              if (hasFileChanges) const FileChangedWidget(),
              if (isSearching) SearchWidget(),
              if (items.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: Text('Nothing to see here ¯\\_(ツ)_/¯')),
                ),
            ]
          )
        ),
        if (items.isNotEmpty)
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
              child: ScrollConfiguration(
                behavior: _ScrollBehavior(),
                child: ScrollablePositionedList.builder(
                  itemCount: items.length,
                  itemScrollController: controller,
                  itemBuilder: (_, i) => ItemWidget(items[i]),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics();
  }
}