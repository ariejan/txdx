import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:txdx/providers/items/item_notifier_provider.dart';

import '../config/shortcuts.dart';
import '../providers/items/selected_item_provider.dart';

class EndEditAction extends Action<EndEditIntent> {

  final WidgetRef ref;

  final TextEditingController descriptionController;

  EndEditAction(this.ref, this.descriptionController);

  @override
  Object? invoke(EndEditIntent intent) {
    print('Ending edit');
    print(descriptionController.text);

    final editedItemId = ref.read(editingItemIdStateProvider);

    if (editedItemId == null) {
      return null;
    }

    // ref.read(itemsNotifierProvider.notifier).updateItem(editedItemId, );

    ref.read(editingItemIdStateProvider.state).state = null;
    return null;
  }
}