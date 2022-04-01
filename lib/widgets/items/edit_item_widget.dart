import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:txdx/txdx/txdx_item.dart';

import '../../providers/items/item_notifier_provider.dart';
import '../../providers/items/selected_item_provider.dart';

class EditItemWidget extends ConsumerWidget {

  final TxDxItem item;

  final _focusNode = FocusNode();
  final _textController = TextEditingController();

  EditItemWidget(this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _focusNode.requestFocus();

    _textController.text = item.toString();

    return Form(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Focus(
                      onKey: (FocusNode node, RawKeyEvent event) {
                        if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
                          ref.read(itemsNotifierProvider.notifier).updateItem(item.id, _textController.text);
                          ref.read(editingItemIdStateProvider.state).state = null;
                          return KeyEventResult.handled;
                        }
                        return KeyEventResult.ignored;
                      },
                      child: TextFormField(
                        focusNode: _focusNode,
                        controller: _textController,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const FaIcon(
                      FontAwesomeIcons.trash,
                      size: 16,
                    ),
                    color: Theme.of(context).errorColor,
                    onPressed: () {
                      ref.read(editingItemIdStateProvider.state).state = null;
                      ref.read(itemsNotifierProvider.notifier).deleteItem(item.id);
                    },
                  ),
                ],
              ),
            ),
          ]
      ),
    );
  }

}