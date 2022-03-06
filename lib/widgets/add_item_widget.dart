import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:txdx/providers/selected_item_provider.dart';

import '../providers/item_notifier_provider.dart';

class AddItemWidget extends ConsumerWidget {
  AddItemWidget({Key? key}) : super(key: key);

  void _createItem(WidgetRef ref, String? value) {
    ref.read(itemsNotifierProvider.notifier).createItem(value);
    textController.text = '';
  }

  final textController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onSubmitted: (_) {
                _createItem(ref, textController.text);
              },
              onTap: () {
                ref.read(selectedItemIdStateProvider.state).state = null;
              },
              controller: textController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '(A) Create a new todo item @txdx',
              ),
            ),
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.plusSquare),
            onPressed: () {
              _createItem(ref, textController.text);
            },
          )
        ]
      )
    );
  }


}