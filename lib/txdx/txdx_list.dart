import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'txdx.dart';
import 'txdx_item.dart';

final sharedPreferencesProvider = FutureProvider(
  (ref) async => SharedPreferences.getInstance(),
);

final filenameNotifierProvider =
  StateNotifierProvider<FilenameNotifier, AsyncValue<String?>>(
    (ref) => FilenameNotifier(ref.read),
  );

class FilenameNotifier extends StateNotifier<AsyncValue<String?>> {
  FilenameNotifier(this.read) : super(const AsyncValue<String?>.loading()) {
    // Can't await _initialize method.
    _initialize();
  }

  final Reader read;

  Future<void> _initialize() async {
    await Future<void>.delayed(const Duration(seconds: 1)); // TODO: Remove this
    final prefs = await read(sharedPreferencesProvider.future);
    state = AsyncValue.data(prefs.getString('filename'));
  }

  Future<void> setFilename(String filename) async {
    state = AsyncValue.data(filename);
    final prefs = await read(sharedPreferencesProvider.future);
    await prefs.setString('filename', filename);
  }
}

final itemsNotifierProvider =
  StateNotifierProvider.autoDispose<ItemNotifier, AsyncValue<List<TxDxItem>>>((ref) {
      return ItemNotifier(ref);
    },
);

class ItemNotifier extends StateNotifier<AsyncValue<List<TxDxItem>>> {
  ItemNotifier(this.ref) : super(const AsyncValue<List<TxDxItem>>.loading()) {
    _initialize();
  }

  final AutoDisposeStateNotifierProviderRef ref;
  late final String filename;

  Future<void> _initialize() async {
    final _filename = await ref.watch(filenameNotifierProvider.future);
    if (_filename != null && _filename != '') {
      final theItems = await TxDxFile.openFromFile(_filename);
      state = AsyncValue.data(theItems);
    } else {
      state = const AsyncValue.data(<TxDxItem>[]);
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
      state = AsyncValue.data(items);
    }
  }
}