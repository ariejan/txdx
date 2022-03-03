import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/providers/scoped_item_notifier.dart';
import 'package:txdx/widgets/item_group_widget.dart';

import 'menu_header_widget.dart';

class ItemsListView extends ConsumerWidget {
  const ItemsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(builder: (context, ref, _) {
      final items = ref.watch(groupedItems);
      final groupList = <Widget>[];

      for (var groupName in items.keys) {
        final groupItems = items[groupName] ?? [];
        groupList.add(ItemGroupWidget(groupName, groupItems));
      }

      return Column(
        children: [
          MenuHeaderWidget(
            ref.read(itemFilter) ?? 'Everything',
            margin: const EdgeInsets.fromLTRB(0, 12, 0, 0),
          ),
          ...groupList,
        ],
      );
    });
  }
}
