import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/txdx/txdx.dart';

import 'item_widget.dart';

class ItemsListView extends ConsumerWidget {
  const ItemsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(builder: (context, ref, _) {
      final items = ref.watch(itemsNotifierProvider);
      return items.map(
        data: (data) {
          final theItems = data.value;
          return ListView.builder(
            itemCount: theItems.length,
            itemBuilder: (_, i) {
              final item = theItems[i];
              return ItemWidget(
                item,
                onCompletedToggle: (bool value) {
                  ref.read(itemsNotifierProvider.notifier).toggleComplete(item.id);
                },
              );
            },
          );
        },
        loading: (_) => const Center(child: CircularProgressIndicator()),
        error: (_) => const Text('Error...'),
      );
    });
  }

}