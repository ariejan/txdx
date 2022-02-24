import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../providers/item_notifier_provider.dart';

class AddItemWidget extends ConsumerWidget {
  const AddItemWidget({Key? key}) : super(key: key);

  void _createItem(WidgetRef ref, String? value) {
    ref.read(itemsNotifierProvider.notifier).createNewItem(value);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '(A) Create a new todo item @txdx',
              ),
            ),
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.plusSquare),
            color: Get.theme.primaryIconTheme.color,
            onPressed: () {
              _createItem()
            },
          )
        ]
      )
    );
  }
}