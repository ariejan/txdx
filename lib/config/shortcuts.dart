import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:txdx/actions/end_edit_action.dart';

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

final priorityUpShortcut = LogicalKeySet(
  Platform.isMacOS ? LogicalKeyboardKey.meta : LogicalKeyboardKey.control,
  LogicalKeyboardKey.arrowUp
);

final priorityDownShortcut = LogicalKeySet(
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
class ArchiveItemsIntent extends Intent {}

class EndEditIntent extends Intent {
  const EndEditIntent(this.itemControllers);

  final ItemControllers itemControllers;
}

class DeleteTagIntent extends Intent {
  const DeleteTagIntent(this.itemId, this.tag);

  final String itemId;
  final String tag;
}