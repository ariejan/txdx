import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:quiver/core.dart';
import 'package:txdx/providers/items/item_notifier_provider.dart';
import 'package:txdx/providers/items/scoped_item_notifier.dart';
import 'package:txdx/utils/focus.dart';

import '../config/shortcuts.dart';
import '../providers/items/selected_item_provider.dart';
import '../txdx/txdx_item.dart';

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
    final editedItemId = ref.read(editingItemIdStateProvider);
    if (editedItemId == null) {
      return null;
    }

    final items = ref.read(filteredItems);
    final theItem = items.firstWhere((item) => item.id == editedItemId);

    final dueOnStr = itemControllers.dueOnController.text;
    final descriptionStr = itemControllers.descriptionController.text;

    final parsedItem = TxDxItem.fromText(descriptionStr);

    final newItem = theItem.copyWith(
      description: parsedItem.description,
      priority: (parsedItem.priority?.isNotEmpty ?? false) ? Optional.of(parsedItem.priority!) : null,
    ).setDueOn(dueOnStr.isEmpty ? null : DateTime.tryParse(dueOnStr));

    ref.read(itemsNotifierProvider.notifier).updateItem(editedItemId, newItem.toString());
    ref.read(editingItemIdStateProvider.state).state = null;

    appFocusNode.requestFocus();

    return null;
  }
}