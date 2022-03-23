import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/providers/scoped_item_notifier.dart';
import 'package:txdx/widgets/item_group_widget.dart';

import 'menu_header_widget.dart';

class ItemsListView extends ConsumerWidget {
  const ItemsListView({Key? key}) : super(key: key);

  String _getTitle(String? filter) {
    if (filter == null || filter == 'all') {
      return 'Everything';
    }
    return filter;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(builder: (context, ref, _) {
      final items = ref.watch(groupedItems);
      final groupList = <Widget>[];

      if (items.isEmpty) {
        groupList.add(const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Text('Nothing to see here ¯\\_(ツ)_/¯')
          ),
        ));
      } else {
        for (var groupName in items.keys) {
          final groupItems = items[groupName] ?? [];
          groupList.add(ItemGroupWidget(groupName, groupItems));
        }
      }

      return Column(
        children: [
          MenuHeaderWidget(
            _getTitle(ref.read(itemFilter)),
            margin: const EdgeInsets.fromLTRB(0, 12, 0, 0),
          ),
          ...groupList,
        ],
      );
    });
  }
}
