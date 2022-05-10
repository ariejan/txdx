import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'context_menu.dart';

/// The [ContextMenuArea] is the way to use a [ContextMenu]
///
/// It listens for right click and long press and executes [showContextMenu]
/// with the corresponding location [Offset].

class ContextMenuArea extends ConsumerWidget {
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

  final Function? onHighlight;
  final Function? onDismiss;

  const ContextMenuArea({
    Key? key,
    required this.child,
    required this.items,
    this.verticalPadding = 8,
    this.width = 240,
    this.onHighlight,
    this.onDismiss,
  }) : super(key: key);

  void showContextMenu(
      Offset offset,
      BuildContext context,
      List<Widget> children,
      verticalPadding,
      width,
      ) async {
    onHighlight?.call();
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
    ).whenComplete(() => onDismiss?.call());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onSecondaryTapDown: (details) {
        showContextMenu(
          details.globalPosition,
          context,
          items,
          verticalPadding,
          width,
        );
      },
      onLongPressStart: (details) {
        showContextMenu(
          details.globalPosition,
          context,
          items,
          verticalPadding,
          width,
        );
      },
      child: child,
    );
  }
}
