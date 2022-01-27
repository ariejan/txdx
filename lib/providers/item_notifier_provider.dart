import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/txdx/txdx_file.dart';
import 'package:txdx/txdx/txdx_item.dart';

import 'file_notifier_provider.dart';

final itemsNotifierProvider =
  StateNotifierProvider<ItemNotifier, AsyncValue<List<TxDxItem>>>((ref) => ItemNotifier(ref));

class ItemNotifier extends StateNotifier<AsyncValue<List<TxDxItem>>> {
  ItemNotifier(this.ref) : super(const AsyncValue<List<TxDxItem>>.loading()) {
    _initialize();
  }

  final StateNotifierProviderRef ref;
  late final String? filename;

  Future<void> _initialize() async {
    filename = await ref.watch(filenameNotifierProvider.future);
    if (filename != null && filename != '') {
      final theItems = await TxDxFile.openFromFile(filename!);
      state = AsyncValue.data(theItems);
    } else {
      state = const AsyncValue.data(<TxDxItem>[]);
    }
  }

  List<TxDxItem> getItems() {
    return state.value ?? [];
  }

  Future<void> createNewItem() async {
    final items = state.value ?? [];
    final theItems = [
      ...items,
      TxDxItem.fromText('New item')
    ];
    _setState(theItems);
  }

  Future<void> toggleComplete(String id) async {
    final items = state.value;
    if (items == null) {
      return;
    }
    final itemIdx = items.indexWhere((item) => item.id == id);
    if (itemIdx >= 0) {
      final theItem = items.elementAt(itemIdx);
      items.replaceRange(itemIdx, itemIdx + 1, [theItem.toggleComplete()]);
      _setState(items);
    }
  }

  void _setState(List<TxDxItem> value) {
    state = AsyncValue.data(value);

    if (filename != null && filename != '') {
      TxDxFile.saveToFile(filename!, value);
    }
  }
}