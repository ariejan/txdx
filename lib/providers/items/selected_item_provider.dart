import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/providers/items/item_notifier_provider.dart';

import '../../txdx/txdx_item.dart';

final editingItemIdStateProvider = StateProvider<String?>((ref) {
  return null;
});

final isEditingProvider = Provider<bool>((ref) => ref.watch(editingItemIdStateProvider) != null);

final selectedItemIdStateProvider = StateProvider<String?>((ref) {
  return null;
});

final contextMenuItemIdStateProvider = StateProvider<String?>((ref) {
  return null;
});

final itemProvider = StateProvider.family<TxDxItem?, String>((ref, id) {
  var items = ref.watch(todoItemsProvider);
  final itemIdx = items.indexWhere((item) => item.id == id);

  if (itemIdx >= 0) {
    final theItem = items.elementAt(itemIdx);
    return theItem;
  } else {
    return null;
  }
});