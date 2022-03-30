import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import 'context_menu.dart';

/// Show a [ContextMenu] on the given [BuildContext]. For other parameters, see [ContextMenu].
void showContextMenu(
    Offset offset,
    BuildContext context,
    List<Widget> children,
    verticalPadding,
    width,
    ) {
  showModal(
    context: context,
    configuration: const FadeScaleTransitionConfiguration(
      barrierColor: Colors.transparent,
    ),
    builder: (context) => ContextMenu(
      position: offset,
      children: children,
      verticalPadding: verticalPadding,
      width: width,
    ),
  );
}

/// The [ContextMenuArea] is the way to use a [ContextMenu]
///
/// It listens for right click and long press and executes [showContextMenu]
/// with the corresponding location [Offset].

class ContextMenuArea extends StatelessWidget {
  /// The widget displayed inside the [ContextMenuArea]
  final Widget child;

  /// A [List] of items to be displayed in an opened [ContextMenu]
  ///
  /// Usually, a [ListTile] might be the way to go.
  final List<Widget> items;

  /// The padding value at the top an bottom between the edge of the [ContextMenu] and the first / last item
  final double verticalPadding;

  /// The width for the [ContextMenu]. 320 by default according to Material Design specs.
  final double width;

  const ContextMenuArea({
    Key? key,
    required this.child,
    required this.items,
    this.verticalPadding = 8,
    this.width = 320,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTapDown: (details) => showContextMenu(
        details.globalPosition,
        context,
        items,
        verticalPadding,
        width,
      ),
      onLongPressStart: (details) => showContextMenu(
        details.globalPosition,
        context,
        items,
        verticalPadding,
        width,
      ),
      child: child,
    );
  }
}
