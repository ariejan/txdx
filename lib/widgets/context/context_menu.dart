import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';

import '../../config/colors.dart';

const double _kMinTileHeight = 24;

/// The actual [ContextMenu] to be displayed
///
/// You will most likely use [showContextMenu] to manually display a [ContextMenu].
///
/// If you just want to use a normal [ContextMenu], please use [ContextMenuArea].

class ContextMenu extends StatefulWidget {
  /// The [Offset] from coordinate origin the [ContextMenu] will be displayed at.
  final Offset position;

  /// The items to be displayed. [ListTile] is very useful in most cases.
  final List<Widget> children;

  /// The padding value at the top an bottom between the edge of the [ContextMenu] and the first / last item
  final double verticalPadding;

  /// The width for the [ContextMenu]. 320 by default according to Material Design specs.
  final double width;

  const ContextMenu({
    Key? key,
    required this.position,
    required this.children,
    this.verticalPadding = 8,
    this.width = 320,
  }) : super(key: key);

  @override
  _ContextMenuState createState() => _ContextMenuState();
}

class _ContextMenuState extends State<ContextMenu> {
  final Map<ValueKey, double> _heights = {};

  @override
  Widget build(BuildContext context) {
    double height = 2 * widget.verticalPadding;

    for (var element in _heights.values) {
      height += element;
    }

    final heightsNotAvailable = widget.children.length - _heights.length;
    height += heightsNotAvailable * _kMinTileHeight;

    if (height > MediaQuery.of(context).size.height) {
      height = MediaQuery.of(context).size.height;
    }

    double paddingLeft = widget.position.dx;
    double paddingTop = widget.position.dy;
    double paddingRight =
        MediaQuery.of(context).size.width - widget.position.dx - widget.width;
    if (paddingRight < 0) {
      paddingLeft += paddingRight;
      paddingRight = 0;
    }
    double paddingBottom =
        MediaQuery.of(context).size.height - widget.position.dy - height;
    if (paddingBottom < 0) {
      paddingTop += paddingBottom;
      paddingBottom = 0;
    }
    return AnimatedPadding(
      padding: EdgeInsets.fromLTRB(
        paddingLeft,
        paddingTop,
        paddingRight,
        paddingBottom,
      ),
      duration: _kShortDuration,
      child: SizedBox.shrink(
        child: Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Material(
              color: Theme.of(context).brightness == Brightness.dark
                  ? TxDxColors.darkContextBackgroundColor
                  : TxDxColors.lightContextBackgroundColor,
              child: ListView(
                primary: false,
                shrinkWrap: true,
                padding: EdgeInsets.all(widget.verticalPadding),
                children: widget.children
                    .map(
                      (e) => _GrowingWidget(
                    child: e,
                    onHeightChange: (height) {
                      setState(() {
                        _heights[ValueKey(e)] = height;
                      });
                    },
                  ),
                )
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

const _kShortDuration = Duration(milliseconds: 75);

class _GrowingWidget extends StatefulWidget {
  final Widget child;
  final ValueChanged<double> onHeightChange;

  const _GrowingWidget(
      {Key? key, required this.child, required this.onHeightChange})
      : super(key: key);

  @override
  __GrowingWidgetState createState() => __GrowingWidgetState();
}

class __GrowingWidgetState extends State<_GrowingWidget> with AfterLayoutMixin {
  final GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.child,
      key: _key,
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    final newHeight = _key.currentContext!.size!.height;
    widget.onHeightChange.call(newHeight);
  }
}
