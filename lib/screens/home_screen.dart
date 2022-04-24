
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/actions/delete_item_action.dart';
import 'package:txdx/actions/select_previous_item_action.dart';
import 'package:txdx/actions/start_edit_action.dart';
import 'package:txdx/actions/start_search_action.dart';
import 'package:txdx/actions/toggle_completion_action.dart';
import 'package:txdx/config/shortcuts.dart';
import 'package:txdx/widgets/items/items_list_view.dart';
import 'package:txdx/widgets/misc/no_txdx_directory_widget.dart';
import 'package:txdx/widgets/navigation/sidebar_widget.dart';
import 'package:txdx/widgets/layout/split_view.dart';

import '../actions/add_item_action.dart';
import '../actions/cancel_search_and_edit_action.dart';
import '../actions/change_priority_down_action.dart';
import '../actions/change_priority_up_action.dart';
import '../actions/select_next_item_action.dart';
import '../config/settings.dart';
import '../providers/settings/settings_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txdxDir = ref.watch(fileSettingsProvider).getString(settingsTxDxDirectory);
    final hasTodoTxt = txdxDir?.isNotEmpty ?? false;

    return Shortcuts(
      shortcuts: {
        arrowUpShortcut: SelectPreviousItemIntent(),
        arrowDownShortcut: SelectNextItemIntent(),
        escapeShortcut: CancelActionIntent(),
        searchShortcut: SearchIntent(),
        enterShortcut: EditIntent(),
        addShortcut: AddIntent(),
        priorityUpShortcut: ChangePriorityUpIntent(),
        priorityDownShortcut: ChangePriorityDownIntent(),
        toggleCompletedShortcut: ToggleCompletionIntent(),
        deleteShortcut: DeleteIntent(),
        backspaceShortcut: DeleteIntent(),
      },
      child: Actions(
        actions: {
          SelectPreviousItemIntent: SelectPreviousItemAction(ref),
          SelectNextItemIntent: SelectNextItemAction(ref),
          CancelActionIntent: CancelSearchAndEditAction(ref),
          SearchIntent: StartSearchAction(ref),
          EditIntent: StartEditAction(ref),
          AddIntent: AddItemAction(ref),
          ChangePriorityUpIntent: ChangePriorityUpAction(ref),
          ChangePriorityDownIntent: ChangePriorityDownAction(ref),
          ToggleCompletionIntent: ToggleCompletionAction(ref),
          DeleteIntent: DeleteItemAction(ref),
        },
        child: Material(
          child: Focus(
            autofocus: true,
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
                      child: hasTodoTxt ? const ItemsListView() : const NoTxDxDirectoryWidget(),
                    ),
                    // SizedBox(
                    //   child: AddItemWidget(),
                    // ),
                  ],
                ),
              )
            ),
          ),
        ),
      ),
    );
  }
}