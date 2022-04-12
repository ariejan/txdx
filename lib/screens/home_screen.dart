
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/input/shortcuts.dart';
import 'package:txdx/providers/items/item_notifier_provider.dart';
import 'package:txdx/widgets/items/add_item_widget.dart';
import 'package:txdx/widgets/items/items_list_view.dart';
import 'package:txdx/widgets/misc/no_file_selected_widget.dart';
import 'package:txdx/widgets/navigation/sidebar_widget.dart';
import 'package:txdx/widgets/layout/split_view.dart';

import '../config/settings.dart';
import '../input/focus.dart';
import '../providers/items/scoped_item_notifier.dart';
import '../providers/items/selected_item_provider.dart';
import '../providers/settings/settings_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void _jumpTo(int index) {
    ItemsListView.controller.scrollTo(
      index: index,
      duration: const Duration(microseconds: 250),
      alignment: 0.33,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filename = ref.watch(settingsProvider).getString(settingsFileTodoTxt);
    final hasTodoTxt = filename?.isNotEmpty ?? false;

    void _moveToNextItem() {
      final items = ref.read(filteredItems);
      final current = ref.read(selectedItemIdStateProvider);
      if (current == null) {
        ref.read(selectedItemIdStateProvider.state).state = items.first.id;
        _jumpTo(0);
      } else {
        final idx = (items.indexWhere((item) => item.id == current) + 1) % items.length;
        ref.read(selectedItemIdStateProvider.state).state = items[idx].id;
        _jumpTo(idx);
      }
    }

    void _moveToPreviousItem() {
      final items = ref.read(filteredItems);
      final current = ref.read(selectedItemIdStateProvider);
      if (current == null) {
        ref.read(selectedItemIdStateProvider.state).state = items.last.id;
        _jumpTo(items.length - 1);
      } else {
        final idx = (items.indexWhere((item) => item.id == current) - 1) % items.length;
        ref.read(selectedItemIdStateProvider.state).state = items[idx].id;
        _jumpTo(idx);
      }
    }

    return AppShortcuts(
      onCancelEditingDetected: () {
        if (ref.read(isSearchingProvider)) {
          ref.read(searchTextProvider.state).state = null;
          ref.read(isSearchingProvider.state).state = false;
        } else {
          ref
              .read(editingItemIdStateProvider.state)
              .state = null;
          shortcutsFocusNode.requestFocus();
        }
      },
      onAddNew: () {
        ref.read(editingItemIdStateProvider.state).state = null;
        ref.read(selectedItemIdStateProvider.state).state = null;
        addNewFocusNode.requestFocus();
      },
      onDown: () {
        shortcutsFocusNode.requestFocus();
        _moveToNextItem();
      },
      onUp: () {
        shortcutsFocusNode.requestFocus();
        _moveToPreviousItem();
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

        final items = ref.read(filteredItems);
        var idx = items.indexWhere((item) => item.id == current);
        final item = items[idx];

        if (!item.completed) {
          idx = (idx + 1 >= items.length) ? items.length - 2 : idx + 1;
          ref.read(selectedItemIdStateProvider.state).state = items[idx].id;
        }

        ref.read(itemsNotifierProvider.notifier).toggleComplete(current);
      },
      onMoveToToday: () {
        final current = ref.read(selectedItemIdStateProvider);
        if (current == null) return;

        ref.read(itemsNotifierProvider.notifier).moveToToday(current);
      },
      onDelete: () {
        final current = ref.read(selectedItemIdStateProvider);
        if (current == null) return;

        final items = ref.read(filteredItems);
        var idx = items.indexWhere((item) => item.id == current);
        idx = (idx + 1 >= items.length) ? items.length - 2 : idx + 1;

        ref.read(selectedItemIdStateProvider.state).state = items[idx].id;

        ref.read(itemsNotifierProvider.notifier).deleteItem(current);
      },
      onTab: () {
        return;
      },
      onSearch: () {
        ref.read(searchTextProvider.state).state = '';
        ref.read(isSearchingProvider.state).state = true;
        searchFocusNode.requestFocus();
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
                Expanded(
                  flex: 2,
                  child: hasTodoTxt ? const ItemsListView() : const NoFileSelectedWidget(),
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