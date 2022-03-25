
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/input/shortcuts.dart';
import 'package:txdx/providers/item_notifier_provider.dart';
import 'package:txdx/widgets/add_item_widget.dart';
import 'package:txdx/widgets/items_list_view.dart';
import 'package:txdx/widgets/sidebar_widget.dart';
import 'package:txdx/widgets/split_view.dart';

import '../input/focus.dart';
import '../providers/scoped_item_notifier.dart';
import '../providers/selected_item_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppShortcuts(
      onCancelEditingDetected: () {
        ref.read(editingItemIdStateProvider.state).state = null;
        shortcutsFocusNode.requestFocus();
      },
      onAddNew: () {
        ref.read(editingItemIdStateProvider.state).state = null;
        ref.read(selectedItemIdStateProvider.state).state = null;
        addNewFocusNode.requestFocus();
      },
      onDown: () {
        shortcutsFocusNode.requestFocus();

        final items = ref.read(filteredItems);
        final current = ref.read(selectedItemIdStateProvider);
        if (current == null) {
          ref.read(selectedItemIdStateProvider.state).state = items.first.id;
        } else {
          final idx = (items.indexWhere((item) => item.id == current) + 1) % items.length;
          ref.read(selectedItemIdStateProvider.state).state = items[idx].id;
        }
      },
      onUp: () {
        shortcutsFocusNode.requestFocus();

        final items = ref.read(filteredItems);
        final current = ref.read(selectedItemIdStateProvider);
        if (current == null) {
          ref.read(selectedItemIdStateProvider.state).state = items.last.id;
        } else {
          final idx = (items.indexWhere((item) => item.id == current) - 1) % items.length;
          ref.read(selectedItemIdStateProvider.state).state = items[idx].id;
        }
      },
      onPrioDown: () {
        final current = ref.read(selectedItemIdStateProvider);
        if (current == null) return;

        ref.read(itemsNotifierProvider.notifier).prioDown(current);
      },
      onPrioUp: () {
        final current = ref.read(selectedItemIdStateProvider);
        if (current == null) return;

        ref.read(itemsNotifierProvider.notifier).prioUp(current);
      },
      onStartEdit: () {
        final current = ref.read(selectedItemIdStateProvider);
        if (current == null) return;

        ref.read(editingItemIdStateProvider.state).state = current;
      },
      onToggle: () {
        final current = ref.read(selectedItemIdStateProvider);
        if (current == null) return;

        ref.read(itemsNotifierProvider.notifier).toggleComplete(current);
      },
      onDelete: () {
        final current = ref.read(selectedItemIdStateProvider);
        if (current == null) return;

        final items = ref.read(filteredItems);
        var idx = items.indexWhere((item) => item.id == current);
        idx = (idx - 1 < 0) ? 0 : idx - 1;

        ref.read(selectedItemIdStateProvider.state).state = items[idx].id;

        ref.read(itemsNotifierProvider.notifier).deleteItem(current);
      },
      child: Material(
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
      ),
    );
  }
}