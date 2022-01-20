import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'txdx_item.dart';

class TxDxList extends StateNotifier<List<TxDxItem>>{
  TxDxList([List<TxDxItem>? initialTodos]) : super(initialTodos ?? []);

  void add(String text) {
    state = [
      ...state,
      TxDxItem.fromText(text),
    ];
  }

  void toggle(String id) {
    state = [
      for (final item in state)
        if (item.id == id)
          item.toggleComplete()
        else
          item,
    ];
  }

  void remove(String id) {
    state = state.where((item) => item.id != id).toList();
  }
}