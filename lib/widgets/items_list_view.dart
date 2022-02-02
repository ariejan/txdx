import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/providers/item_notifier_provider.dart';
import 'package:txdx/providers/scoped_item_notifier.dart';
import 'package:txdx/txdx/txdx_item.dart';
import 'package:txdx/widgets/item_group_widget.dart';

import 'item_widget.dart';

class ItemsListView extends ConsumerWidget {
  const ItemsListView({Key? key}) : super(key: key);

  // Widget _getMappedItemWidgets(WidgetRef ref, Map<String, List<TxDxItem>> mappedItems) {
  //   var widgets = <Widget>[];
  //
  //   for (var group in mappedItems.keys) {
  //     widgets.add(SizedBox(child: Text(group)));
  //
  //     final groupItems = mappedItems[group] ?? [];
  //     widgets.add();
  //   }
  //
  //   return Column(children: widgets);
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(builder: (context, ref, _) {
      final itemsMap = ref.watch(groupedItems);

      return itemsMap.map(
        data: (data) {
          final theItems = data.value;
          final groupList = <Widget>[];

          for (var groupName in theItems.keys) {
            final groupItems = theItems[groupName] ?? [];
            groupList.add(ItemGroupWidget(groupName, groupItems));
          }

          return Column(
            children: groupList,
          );
        },
        loading: (_) => const Center(child: CircularProgressIndicator()),
        error: (_) => const Text('Error...'),
      );
    });
  }
}
