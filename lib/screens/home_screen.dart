
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/providers/item_notifier_provider.dart';
import 'package:txdx/providers/selected_item_provider.dart';
import 'package:txdx/widgets/add_item_widget.dart';
import 'package:txdx/widgets/editor_widget.dart';
import 'package:txdx/widgets/items_list_view.dart';
import 'package:txdx/widgets/sidebar_widget.dart';
import 'package:txdx/widgets/split_view.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedItemId = ref.watch(selectedItemIdStateProvider);

    return Material(
      child: SplitView(
        sidebarWidth: 220,
        editorWidth: 520,
        showEditor: selectedItemId != null,
        sidebar: const SidebarWidget(),
        editor: EditorWidget(),
        content: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(
            children: [
              const Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  child: ItemsListView(),
                ),
              ),
              SizedBox(
                child: AddItemWidget(),
              ),
            ],
          ),
        )
      ),
    );
  }
}