import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:txdx/providers/scoped_item_notifier.dart';
import 'package:txdx/providers/settings_provider.dart';
import 'package:txdx/settings.dart';

import '../providers/file_change_provider.dart';
import '../providers/item_notifier_provider.dart';
import 'file_changed_widget.dart';
import 'item_widget.dart';
import 'menu_header_widget.dart';

class ItemsListView extends ConsumerWidget {
  static ItemScrollController controller = ItemScrollController();

  const ItemsListView({Key? key}) : super(key: key);

  String _getTitle(WidgetRef ref) {
    final filter = ref.read(itemFilter);
    final upcomingDays = ref.read(settingsProvider).getInt(settingsNextUpDays);

    switch (filter) {
      case null:
      case 'all':
        return 'Everything';
      case 'due:today':
        return 'Today';
      case 'due:upcoming':
        return 'Next $upcomingDays days';
      case 'due:overdue':
        return 'Overdue';
      case 'due:someday':
        return 'Someday';
      default:
        return filter!;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasFileChanges = ref.watch(fileWasChanged);
    final items = ref.watch(filteredItems);

    return Column(
      children: [
        SizedBox(
          child: Column(
            children: [
              MenuHeaderWidget(
                _getTitle(ref),
                margin: const EdgeInsets.fromLTRB(0, 12, 0, 0),
              ),
              if (hasFileChanges) const FileChangedWidget(),
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
            child: ScrollConfiguration(
              behavior: _ScrollBehavior(),
              child: ScrollablePositionedList.builder(
                itemCount: items.length,
                itemScrollController: controller,
                itemBuilder: (_, i) {
                  final item = items[i];
                  return ItemWidget(
                    item,
                    onCompletedToggle: (bool value) {
                      ref
                          .read(itemsNotifierProvider.notifier)
                          .toggleComplete(item.id);
                    },
                  );
                },
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