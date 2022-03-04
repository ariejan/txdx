
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/widgets/add_item_widget.dart';
import 'package:txdx/widgets/items_list_view.dart';
import 'package:txdx/widgets/sidebar_widget.dart';
import 'package:txdx/widgets/split_view.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      child: SplitView(
        sidebarWidth: 220,
        editorWidth: 0,
        showEditor: false,
        sidebar: const SidebarWidget(),
        editor: Container(),
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