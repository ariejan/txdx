import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/input/focus.dart';
import 'package:txdx/providers/selected_item_provider.dart';

import '../providers/item_notifier_provider.dart';

class AddItemWidget extends ConsumerWidget {
  AddItemWidget({Key? key}) : super(key: key);

  void _createItem(WidgetRef ref, String? value) {
    final newItemId = ref.read(itemsNotifierProvider.notifier).createItem(value);
    textController.text = '';
    ref.read(selectedItemIdStateProvider.state).state = newItemId;
    shortcutsFocusNode.requestFocus();
  }

  final textController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
      child: Row(
        children: [
          Expanded(
            child: Focus(
              onKey: (FocusNode node, RawKeyEvent event) {
                if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
                  _createItem(ref, textController.text);
                  return KeyEventResult.handled;
                }
                return KeyEventResult.ignored;
              },
              child: TextField(
                onTap: () {
                  ref.read(editingItemIdStateProvider.state).state = null;
                },
                focusNode: addNewFocusNode,
                controller: textController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '(A) Create a new todo item @txdx ⏎',
                ),
              ),
            ),
          ),
        ]
      )
    );
  }


}