import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/providers/item_notifier_provider.dart';

import '../txdx/txdx_item.dart';

class EditorForm extends ConsumerWidget {
  EditorForm(this.item, {Key? key}) : super(key: key);

  final TxDxItem item;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(itemsNotifierProvider.notifier);

    return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Column(
              children: [
                Row(
                  children: [
                    Checkbox(
                      shape: const CircleBorder(),
                      value: item.completed,
                      onChanged: (value) {
                        items.toggleComplete(item.id);
                      }),
                    Expanded(
                      child: TextFormField(
                        initialValue: item.description,
                        onChanged: (value) {
                          items.updateItem(item.id, item.copyWith(description: value));
                        },
                      ),
                    ),
                  ],
                ),
              ]
          ),
        )
    );

  }
  
}