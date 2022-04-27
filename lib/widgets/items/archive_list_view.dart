import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:txdx/providers/items/scoped_item_notifier.dart';
import 'package:txdx/widgets/misc/search_widget.dart';

import '../../providers/files/file_change_provider.dart';
import 'item_widget.dart';
import '../navigation/menu_header_widget.dart';

class ArchiveListView extends ConsumerWidget {
  static ItemScrollController controller = ItemScrollController();

  const ArchiveListView({Key? key}) : super(key: key);

  String _getTitle(WidgetRef ref) {
    return "The Archives";
  }

  IconData _getIconData(WidgetRef ref) {
    return Icons.archive_outlined;
  }

  Color? _getIconColor(WidgetRef ref) {
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(archiveFileWasChanged);
    final items = ref.watch(archivedItems);
    final isSearching = ref.watch(isSearchingProvider);

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
                    actions: const [],
                  ),
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
                  itemBuilder: (_, i) => ItemWidget(items[i], archiveView: true),
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