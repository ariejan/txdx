import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:txdx/utils/focus.dart';

final cancelEditingKeySet = LogicalKeySet(
  LogicalKeyboardKey.escape,
);

final addNewKeySet = LogicalKeySet(
  Platform.isMacOS ? LogicalKeyboardKey.meta : LogicalKeyboardKey.control,
  LogicalKeyboardKey.keyN,
);

final downKeySet = LogicalKeySet(
  LogicalKeyboardKey.arrowDown
);

final upKeySet = LogicalKeySet(
  LogicalKeyboardKey.arrowUp
);

final prioDownKeySet = LogicalKeySet(
  Platform.isMacOS ? LogicalKeyboardKey.meta : LogicalKeyboardKey.control,
  LogicalKeyboardKey.arrowDown
);

final prioUpKeySet = LogicalKeySet(
  Platform.isMacOS ? LogicalKeyboardKey.meta : LogicalKeyboardKey.control,
  LogicalKeyboardKey.arrowUp
);

final startEditKeySet = LogicalKeySet(
  LogicalKeyboardKey.enter
);

final toggleCompletionKeySet = LogicalKeySet(
  Platform.isMacOS ? LogicalKeyboardKey.meta : LogicalKeyboardKey.control,
  LogicalKeyboardKey.keyX
);

final moveToTodayKeySet = LogicalKeySet(
  Platform.isMacOS ? LogicalKeyboardKey.meta : LogicalKeyboardKey.control,
  LogicalKeyboardKey.keyT,
);

final deleteKeySet = LogicalKeySet(
  Platform.isMacOS ? LogicalKeyboardKey.meta : LogicalKeyboardKey.control,
  LogicalKeyboardKey.keyD
);

final tabKeySet = LogicalKeySet(
  LogicalKeyboardKey.tab,
);

final searchKeySet = LogicalKeySet(
    Platform.isMacOS ? LogicalKeyboardKey.meta : LogicalKeyboardKey.control,
    LogicalKeyboardKey.keyF
);

class CancelEditingIntent extends Intent {}
class AddNewIntent extends Intent {}
class DownIntent extends Intent {}
class UpIntent extends Intent {}
class PrioDownIntent extends Intent {}
class PrioUpIntent extends Intent {}
class StartEditIntent extends Intent {}
class ToggleCompletionIntent extends Intent {}
class MoveToTodayIntent extends Intent {}
class DeleteItemIntent extends Intent {}
class TabIntent extends Intent {}
class SearchIntent extends Intent {}

class AppShortcuts extends StatelessWidget {
  const AppShortcuts({
    Key? key,
    required this.onCancelEditingDetected,
    required this.onAddNew,
    required this.onDown,
    required this.onUp,
    required this.onPrioDown,
    required this.onPrioUp,
    required this.onStartEdit,
    required this.onToggle,
    required this.onMoveToToday,
    required this.onDelete,
    required this.onTab,
    required this.onSearch,
    required this.child
  }) : super(key: key);

  final Widget child;
  final VoidCallback onCancelEditingDetected;
  final VoidCallback onAddNew;
  final VoidCallback onDown;
  final VoidCallback onUp;
  final VoidCallback onPrioDown;
  final VoidCallback onPrioUp;
  final VoidCallback onStartEdit;
  final VoidCallback onToggle;
  final VoidCallback onMoveToToday;
  final VoidCallback onDelete;
  final VoidCallback onTab;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      autofocus: true,
      focusNode: shortcutsFocusNode,
      shortcuts: {
        cancelEditingKeySet: CancelEditingIntent(),
        addNewKeySet: AddNewIntent(),
        downKeySet: DownIntent(),
        upKeySet: UpIntent(),
        prioDownKeySet: PrioDownIntent(),
        prioUpKeySet: PrioUpIntent(),
        startEditKeySet: StartEditIntent(),
        toggleCompletionKeySet: ToggleCompletionIntent(),
        moveToTodayKeySet: MoveToTodayIntent(),
        deleteKeySet: DeleteItemIntent(),
        tabKeySet: TabIntent(),
        searchKeySet: SearchIntent(),
      },
      actions: {
        CancelEditingIntent:
            CallbackAction(onInvoke: (e) => onCancelEditingDetected.call()),
        AddNewIntent:
            CallbackAction(onInvoke: (e) => onAddNew.call()),
        DownIntent:
            CallbackAction(onInvoke: (e) => onDown.call()),
        UpIntent:
            CallbackAction(onInvoke: (e) => onUp.call()),
        PrioDownIntent:
            CallbackAction(onInvoke: (e) => onPrioDown.call()),
        PrioUpIntent:
            CallbackAction(onInvoke: (e) => onPrioUp.call()),
        StartEditIntent:
            CallbackAction(onInvoke: (e) => onStartEdit.call()),
        ToggleCompletionIntent:
            CallbackAction(onInvoke: (e) => onToggle.call()),
        MoveToTodayIntent:
            CallbackAction(onInvoke: (e) => onMoveToToday.call()),
        DeleteItemIntent:
            CallbackAction(onInvoke: (e) => onDelete.call()),
        TabIntent:
            CallbackAction(onInvoke: (e) => onTab.call()),
        SearchIntent:
            CallbackAction(onInvoke: (e) => onSearch.call()),
      },
      child: child,
    );
  }
}