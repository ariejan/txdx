
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/providers/selected_item_provider.dart';
import 'package:txdx/widgets/editor_form.dart';

class EditorWidget extends ConsumerWidget {
  EditorWidget({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedItemId = ref.watch(selectedItemIdStateProvider);

    if (selectedItemId == null) {
      return _itemNotSelectedWidget();
    }

    final selectedItem = ref.watch(itemProvider(selectedItemId));

    if (selectedItem == null) {
      return _itemNotSelectedWidget();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: EditorForm(selectedItem),
    );
  }

  Widget _itemNotSelectedWidget() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Center(child: Text('No item selected')),
    );
  }
}