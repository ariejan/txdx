import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/providers/item_notifier_provider.dart';

import '../txdx/txdx_item.dart';

final selectedItemIdStateProvider = StateProvider<String?>((ref) {
  return null;
});

final selectedItemProvider = Provider<TxDxItem?>((ref) {
  final selectedItemId = ref.watch(selectedItemIdStateProvider);
  final items = ref.watch(itemsNotifierProvider.notifier);

  return items.getItem(selectedItemId);
});