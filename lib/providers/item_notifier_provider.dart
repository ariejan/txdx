import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
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
      TxDxFile.openFromFile(filename!).then((theItems) {
        state = AsyncValue.data(theItems);
      }).catchError((e) {
        state = const AsyncValue.data([]);
        Get.dialog(
            AlertDialog(
              title: const Text("Cannot open your TODO.txt file!"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    const Text('Oh noes! It seems we cannot open that file for you.'),
                    Text('$filename'),
                    const Text('Please select a file from settings.')
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('Okay'),
                  onPressed: () {
                    Get.back();
                  },
                )
              ],
            ),
        barrierDismissible: false);
      });
    } else {
      state = const AsyncValue.data(<TxDxItem>[]);
    }
  }

  List<TxDxItem> getItems() {
    return state.value ?? [];
  }

  Future<void> createNewItem(String? input) async {
    final items = state.value ?? [];

    if (input != null && input.isNotEmpty) {
      final theItems = [
        ...items,
        TxDxItem.fromText(input),
      ];
      _setState(theItems);
    }
  }

  TxDxItem? getItem(String? id) {
    final items = state.value;
    if (items == null || id == null) {
      return null;
    }
    final itemIdx = items.indexWhere((item) => item.id == id);
    if (itemIdx >= 0) {
      final theItem = items.elementAt(itemIdx);
      return theItem;
    } else {
      return null;
    }
  }

  void updateItem(String id, TxDxItem item) {
    final items = state.value;
    if (items == null) {
      return;
    }
    final itemIdx = items.indexWhere((item) => item.id == id);
    if (itemIdx >= 0) {
      items.replaceRange(itemIdx, itemIdx + 1, [item]);
      _setState(items);
    }
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