
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/actions/archive_items_action.dart';
import 'package:txdx/actions/delete_item_action.dart';
import 'package:txdx/actions/delete_tag_action.dart';
import 'package:txdx/actions/end_edit_action.dart';
import 'package:txdx/actions/select_previous_item_action.dart';
import 'package:txdx/actions/set_priority_action.dart';
import 'package:txdx/actions/start_edit_action.dart';
import 'package:txdx/actions/start_search_action.dart';
import 'package:txdx/actions/toggle_completion_action.dart';
import 'package:txdx/actions/unarchive_item_action.dart';
import 'package:txdx/config/shortcuts.dart';
import 'package:txdx/utils/focus.dart';
import 'package:txdx/widgets/items/items_list_view.dart';
import 'package:txdx/widgets/misc/no_txdx_directory_widget.dart';
import 'package:txdx/widgets/navigation/sidebar_widget.dart';
import 'package:txdx/widgets/layout/split_view.dart';

import '../actions/add_item_action.dart';
import '../actions/cancel_search_and_edit_action.dart';
import '../actions/change_priority_down_action.dart';
import '../actions/change_priority_up_action.dart';
import '../actions/clear_due_on_action.dart';
import '../actions/jump_to_bottom_action.dart';
import '../actions/jump_to_top_action.dart';
import '../actions/move_to_today_action.dart';
import '../actions/select_next_item_action.dart';
import '../config/settings.dart';
import '../providers/items/item_notifier_provider.dart';
import '../providers/settings/settings_provider.dart';
import '../widgets/items/archive_list_view.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txdxDir = ref.watch(fileSettingsProvider).getString(settingsTxDxDirectory);
    final hasTodoTxt = txdxDir?.isNotEmpty ?? false;

    final currentlyAccessibleFile = ref.watch(currentlyAccessibleFileProvider);

    if (!hasTodoTxt) {
      return const NoTxDxDirectoryWidget();
    }

    return Shortcuts(
      shortcuts: {
        arrowUpShortcut: SelectPreviousItemIntent(),
        arrowDownShortcut: SelectNextItemIntent(),
        escapeShortcut: CancelActionIntent(),
        searchShortcut: SearchIntent(),
        enterShortcut: StartEditIntent(),
        addShortcut: AddIntent(),
        jumpUpShortcut: JumpToTopIntent(),
        jumpDownShortcut: JumpToBottomIntent(),
        toggleCompletedShortcut: ToggleCompletionIntent(),
        deleteShortcut: DeleteIntent(),
        backspaceShortcut: DeleteIntent(),
        moveToTodayShortcut: MoveToTodayIntent(),
        clearDueOnShortcut: ClearDueOnIntent(),
        setPriorityAShortcut: const SetPriorityIntent('A'),
        setPriorityBShortcut: const SetPriorityIntent('B'),
        setPriorityCShortcut: const SetPriorityIntent('C'),
        setPriorityDShortcut: const SetPriorityIntent('D'),
        setPriorityXShortcut: const SetPriorityIntent(null),
      },
      child: Actions(
        actions: {
          SelectPreviousItemIntent: SelectPreviousItemAction(ref),
          SelectNextItemIntent: SelectNextItemAction(ref),
          CancelActionIntent: CancelSearchAndEditAction(ref),
          SearchIntent: StartSearchAction(ref),
          StartEditIntent: StartEditAction(ref),
          AddIntent: AddItemAction(ref),
          ChangePriorityUpIntent: ChangePriorityUpAction(ref),
          ChangePriorityDownIntent: ChangePriorityDownAction(ref),
          JumpToTopIntent: JumpToTopAction(ref),
          JumpToBottomIntent: JumpToBottomAction(ref),
          ToggleCompletionIntent: ToggleCompletionAction(ref),
          DeleteIntent: DeleteItemAction(ref),
          MoveToTodayIntent: MoveToTodayAction(ref),
          DeleteTagIntent: DeleteTagAction(ref),
          EndEditIntent: EndEditAction(ref),
          ArchiveItemsIntent: ArchiveItemsAction(ref),
          ClearDueOnIntent: ClearDueOnAction(ref),
          SetPriorityIntent: SetPriorityAction(ref),
          UnarchiveItemIntent: UnarchiveItemAction(ref),
        },
        child: Material(
          child: Focus(
            focusNode: appFocusNode,
            autofocus: true,
            child: SplitView(
              sidebarWidth: 220,
              sidebar: const SidebarWidget(),
              content: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Column(
                  children: [
                    if (currentlyAccessibleFile == AccessibleFile.todo) const Expanded(child: ItemsListView()),
                    if (currentlyAccessibleFile == AccessibleFile.archive) const Expanded(child: ArchiveListView()),
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