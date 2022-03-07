import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:txdx/input/focus.dart';

final cancelEditingKeySet = LogicalKeySet(
  LogicalKeyboardKey.escape,
);

final addNewKeySet = LogicalKeySet(
  LogicalKeyboardKey.meta,
  LogicalKeyboardKey.keyN,
);

final downKeySet = LogicalKeySet(
  LogicalKeyboardKey.arrowDown
);

final upKeySet = LogicalKeySet(
  LogicalKeyboardKey.arrowUp
);

final startEditKeySet = LogicalKeySet(
  LogicalKeyboardKey.enter
);

final toggleCompletionKeySet = LogicalKeySet(
  LogicalKeyboardKey.keyX
);

final deleteKeySet = LogicalKeySet(
  LogicalKeyboardKey.meta,
  LogicalKeyboardKey.keyD
);

class CancelEditingIntent extends Intent {}
class AddNewIntent extends Intent {}
class DownIntent extends Intent {}
class UpIntent extends Intent {}
class StartEditIntent extends Intent {}
class ToggleCompletionIntent extends Intent {}
class DeleteItemIntent extends Intent {}

class AppShortcuts extends StatelessWidget {
  const AppShortcuts({
    Key? key,
    required this.onCancelEditingDetected,
    required this.onAddNew,
    required this.onDown,
    required this.onUp,
    required this.onStartEdit,
    required this.onToggle,
    required this.onDelete,
    required this.child
  }) : super(key: key);

  final Widget child;
  final VoidCallback onCancelEditingDetected;
  final VoidCallback onAddNew;
  final VoidCallback onDown;
  final VoidCallback onUp;
  final VoidCallback onStartEdit;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

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
        startEditKeySet: StartEditIntent(),
        toggleCompletionKeySet: ToggleCompletionIntent(),
        deleteKeySet: DeleteItemIntent(),
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
        StartEditIntent:
            CallbackAction(onInvoke: (e) => onStartEdit.call()),
        ToggleCompletionIntent:
            CallbackAction(onInvoke: (e) => onToggle.call()),
        DeleteItemIntent:
            CallbackAction(onInvoke: (e) => onDelete.call()),
      },
      child: child,
    );
  }
}