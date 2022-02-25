
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/providers/selected_item_provider.dart';
import 'package:txdx/widgets/editor_form.dart';

class EditorWidget extends ConsumerWidget {
  const EditorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = ref.watch(selectedItemProvider);

    if (item == null) {
      return const Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Center(child: Text('No item selected'))
      );
    } else {
      return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: EditorForm(item),
      );
    }
  }
}