import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:txdx/providers/items/item_notifier_provider.dart';
import 'package:txdx/providers/items/scoped_item_notifier.dart';

import '../config/shortcuts.dart';
import '../providers/items/selected_item_provider.dart';

class ItemControllers {

  ItemControllers({
    required this.descriptionController,
    required this.notesController,
    required this.dueOnController
  });

  final TextEditingController descriptionController;
  final TextEditingController notesController;
  final TextEditingController dueOnController;
}


class EndEditAction extends Action<EndEditIntent> {

  final WidgetRef ref;

  final ItemControllers itemControllers;

  EndEditAction(this.ref, this.itemControllers);

  @override
  Object? invoke(EndEditIntent intent) {
    print('Ending edit');

    final editedItemId = ref.read(editingItemIdStateProvider);
    if (editedItemId == null) {
      return null;
    }

    final items = ref.read(filteredItems);
    final theItem = items.firstWhere((item) => item.id == editedItemId);

    final dueOnStr = itemControllers.dueOnController.text;

    final newItem = theItem.copyWith(
      description: itemControllers.descriptionController.text,
    ).setDueOn(dueOnStr.isEmpty ? null : DateTime.tryParse(dueOnStr));

    ref.read(itemsNotifierProvider.notifier).updateItem(editedItemId, newItem.toString());

    ref.read(editingItemIdStateProvider.state).state = null;
    return null;
  }
}