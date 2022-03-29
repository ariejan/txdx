import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/input/focus.dart';
import 'package:txdx/providers/scoped_item_notifier.dart';
import 'package:txdx/providers/selected_item_provider.dart';

import '../providers/item_notifier_provider.dart';
import '../providers/settings_provider.dart';
import '../settings.dart';

class AddItemWidget extends ConsumerWidget {
  AddItemWidget({Key? key}) : super(key: key);

  void _createItem(WidgetRef ref, String? value) {
    final newItemId = ref.read(itemsNotifierProvider.notifier).createItem(value);
    textController.text = '';
    ref.read(selectedItemIdStateProvider.state).state = newItemId;
    addNewFocusNode.requestFocus();
  }

  final textController = TextEditingController();


  void _setTextDefault(String defaultText) {
    final suggestion = " $defaultText";

    textController.value = TextEditingValue(
      text: suggestion,
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  void _focusWithDefaults(WidgetRef ref) {
    final autoAddFilter = ref.read(settingsProvider).getBool(settingsAutoAddFilter);
    if (!autoAddFilter) return;

    final filter = ref.read(itemFilter);
    if (filter == null || filter.isEmpty) return;

    if (filter == 'due:today') {
      _setTextDefault('due:today');
    }

    if (RegExp(r'^[@\+]').hasMatch(filter)) {
      _setTextDefault(filter);
    }
  }

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
              onFocusChange: (focus) {
                if (focus) {
                  if (textController.text.isEmpty) {
                    _focusWithDefaults(ref);
                  }
                } else {
                  textController.clear();
                }
              },
              child: TextField(
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