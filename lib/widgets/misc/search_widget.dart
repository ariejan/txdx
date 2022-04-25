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
              style: const TextStyle(
                fontSize: 14,
              ),
              focusNode: searchFocusNode,
              controller: textController,
              onChanged: (value) {
                ref.read(searchTextProvider.state).state = value;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search_sharp),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear_sharp),
                  onPressed: () => textController.clear(),
                ),
                border: OutlineInputBorder(),
                isDense: true,
                hintText: "Use The Search, Luke!"
              ),
            ),
          ),
        ]
      ),
    );
  }

}