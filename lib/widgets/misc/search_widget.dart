import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/focus.dart';
import '../../providers/items/scoped_item_notifier.dart';

class SearchWidget extends ConsumerWidget {
  SearchWidget({Key? key}) : super(key: key);

  final textController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchText = ref.watch(searchTextProvider) ?? '';
    textController.value = TextEditingValue(
      text: searchText,
      selection: TextSelection.collapsed(offset: searchText.length),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              focusNode: searchFocusNode,
              controller: textController,
              onChanged: (value) {
                ref.read(searchTextProvider.state).state = value;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.clear_sharp),
            splashRadius: 1,
            onPressed: () {
              ref.read(isSearchingProvider.state).state = false;
              ref.read(searchTextProvider.state).state = '';
              appFocusNode.requestFocus();
            },
          )
        ]
      ),
    );
  }

}