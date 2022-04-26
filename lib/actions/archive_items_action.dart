import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../config/shortcuts.dart';
import '../providers/files/file_notifier_provider.dart';
import '../providers/items/item_notifier_provider.dart';
import '../providers/items/scoped_item_notifier.dart';

class ArchiveItemsAction extends Action<ArchiveItemsIntent> {

  final WidgetRef ref;

  ArchiveItemsAction(this.ref);

  @override
  Object? invoke(ArchiveItemsIntent intent) {
    final items = ref.read(filteredItems);
    ref.read(itemsNotifierProvider.notifier).archiveItems(
        items.where((item) => item.completed).map((e) => e.id).toList()
    );

    return null;
  }

  @override
  bool get isActionEnabled {
    return ref.watch(archivingAvailableProvider);
  }
}