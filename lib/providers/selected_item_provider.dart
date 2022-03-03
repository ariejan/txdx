import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/providers/item_notifier_provider.dart';

import '../txdx/txdx_item.dart';

final selectedItemIdStateProvider = StateProvider<String?>((ref) {
  return null;
});

final itemProvider = StateProvider.family<TxDxItem?, String>((ref, id) {
  var asyncItems = ref.watch(itemsNotifierProvider);

  return asyncItems.when(
      data: (items) {
        final itemIdx = items.indexWhere((item) => item.id == id);
        if (itemIdx >= 0) {
          final theItem = items.elementAt(itemIdx);
          return theItem;
        } else {
          return null;
        }
      },
      error: (_, __) => null,
      loading: () => null,
  );
});