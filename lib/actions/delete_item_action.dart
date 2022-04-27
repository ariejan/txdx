import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:txdx/utils/focus.dart';

import '../config/shortcuts.dart';
import '../providers/items/item_notifier_provider.dart';
import '../providers/items/scoped_item_notifier.dart';
import '../providers/items/selected_item_provider.dart';

class DeleteItemAction extends Action<DeleteIntent> {

  final WidgetRef ref;

  DeleteItemAction(this.ref);

  @override
  Object? invoke(DeleteIntent intent) {
    final current = ref.read(selectedItemIdStateProvider);
    if (current != null) {
      final items = ref.read(filteredItems);

      if (items.length > 1) {
        var idx = items.indexWhere((item) => item.id == current);
        idx = (idx + 1 >= items.length) ? items.length - 2 : idx + 1;

        ref
            .read(selectedItemIdStateProvider.state)
            .state = items[idx].id;
      } else {
        ref
            .read(selectedItemIdStateProvider.state)
            .state = null;
      }

      ref.read(todoItemsProvider.notifier).deleteItem(current);
    }

    appFocusNode.requestFocus();

    return null;
  }

  @override
  bool get isActionEnabled {
    final isEditing = ref.watch(isEditingProvider);
    final isSearching = ref.watch(isSearchingProvider);
    return !isEditing && !isSearching;
  }
}