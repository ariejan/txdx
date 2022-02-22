import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/providers/item_notifier_provider.dart';
import 'package:txdx/txdx/txdx_item.dart';
import 'package:txdx/widgets/group_header_widget.dart';

import 'item_widget.dart';

class ItemGroupWidget extends ConsumerWidget {
  const ItemGroupWidget(
      this.groupName,
      this.groupItems,
      {Key? key}) : super(key: key);

  final String groupName;
  final List<TxDxItem> groupItems;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // GroupHeaderWidget(groupName),
        ListView.builder(
          itemCount: groupItems.length,
          shrinkWrap: true,
          itemBuilder: (_, i) {
            final item = groupItems[i];
            return ItemWidget(
              item,
              onCompletedToggle: (bool value) {
                ref.read(itemsNotifierProvider.notifier).toggleComplete(item.id);
              },
            );
          },
        )
      ]
    );
  }

}