import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:txdx/actions/end_edit_action.dart';
import 'package:txdx/actions/set_priority_action.dart';

final arrowDownShortcut = LogicalKeySet(
  LogicalKeyboardKey.arrowDown
);

final arrowUpShortcut = LogicalKeySet(
  LogicalKeyboardKey.arrowUp
);

final enterShortcut = LogicalKeySet(
  LogicalKeyboardKey.enter
);

final escapeShortcut = LogicalKeySet(
  LogicalKeyboardKey.escape
);

final addShortcut = LogicalKeySet(
  Platform.isMacOS ? LogicalKeyboardKey.meta : LogicalKeyboardKey.control,
  LogicalKeyboardKey.keyN
);

final searchShortcut = LogicalKeySet(
  Platform.isMacOS ? LogicalKeyboardKey.meta : LogicalKeyboardKey.control,
  LogicalKeyboardKey.keyF
);

final jumpUpShortcut = LogicalKeySet(
  Platform.isMacOS ? LogicalKeyboardKey.meta : LogicalKeyboardKey.control,
  LogicalKeyboardKey.arrowUp
);

final jumpDownShortcut = LogicalKeySet(
  Platform.isMacOS ? LogicalKeyboardKey.meta : LogicalKeyboardKey.control,
  LogicalKeyboardKey.arrowDown
);

final toggleCompletedShortcut = LogicalKeySet(
  Platform.isMacOS ? LogicalKeyboardKey.meta : LogicalKeyboardKey.control,
  LogicalKeyboardKey.keyX
);

final deleteShortcut = LogicalKeySet(
  LogicalKeyboardKey.delete
);

final backspaceShortcut = LogicalKeySet(
    LogicalKeyboardKey.backspace
);

final moveToTodayShortcut = LogicalKeySet(
  Platform.isMacOS ? LogicalKeyboardKey.meta : LogicalKeyboardKey.control,
  LogicalKeyboardKey.keyT,
);

final clearDueOnShortcut = LogicalKeySet(
  Platform.isMacOS ? LogicalKeyboardKey.meta : LogicalKeyboardKey.control,
  LogicalKeyboardKey.keyK,
);

final setPriorityAShortcut = LogicalKeySet(
  Platform.isMacOS ? LogicalKeyboardKey.meta : LogicalKeyboardKey.control,
  LogicalKeyboardKey.shift,
  LogicalKeyboardKey.keyA,
);

final setPriorityBShortcut = LogicalKeySet(
  Platform.isMacOS ? LogicalKeyboardKey.meta : LogicalKeyboardKey.control,
  LogicalKeyboardKey.shift,
  LogicalKeyboardKey.keyB,
);

final setPriorityCShortcut = LogicalKeySet(
  Platform.isMacOS ? LogicalKeyboardKey.meta : LogicalKeyboardKey.control,
  LogicalKeyboardKey.shift,
  LogicalKeyboardKey.keyC,
);

final setPriorityDShortcut = LogicalKeySet(
  Platform.isMacOS ? LogicalKeyboardKey.meta : LogicalKeyboardKey.control,
  LogicalKeyboardKey.shift,
  LogicalKeyboardKey.keyD,
);

final setPriorityXShortcut = LogicalKeySet(
  Platform.isMacOS ? LogicalKeyboardKey.meta : LogicalKeyboardKey.control,
  LogicalKeyboardKey.shift,
  LogicalKeyboardKey.keyX,
);

class CancelActionIntent extends Intent {}
class SelectPreviousItemIntent extends Intent {}
class SelectNextItemIntent extends Intent {}
class SearchIntent extends Intent {}
class StartEditIntent extends Intent {}
class AddIntent extends Intent {}
class ChangePriorityUpIntent extends Intent {}
class ChangePriorityDownIntent extends Intent {}
class ToggleCompletionIntent extends Intent {}
class DeleteIntent extends Intent {}
class MoveToTodayIntent extends Intent {}
class ClearDueOnIntent extends Intent {}
class ArchiveItemsIntent extends Intent {}
class JumpToTopIntent extends Intent {}
class JumpToBottomIntent extends Intent {}

class SetPriorityIntent extends Intent {
  const SetPriorityIntent(this.priority);

  final String? priority;
}

class EndEditIntent extends Intent {
  const EndEditIntent(this.itemControllers);

  final ItemControllers itemControllers;
}

class DeleteTagIntent extends Intent {
  const DeleteTagIntent(this.itemId, this.tag);

  final String itemId;
  final String tag;
}