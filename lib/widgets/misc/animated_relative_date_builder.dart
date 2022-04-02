import 'package:flutter/material.dart';
import 'package:lit_relative_date_time/lit_relative_date_time.dart';

/// A copy of AnimatedRelativeDateTimeBuilder but uses a fixed date instead
/// of date time.
class AnimatedRelativeDateBuilder extends StatefulWidget {
  /// The [DateTime] the [RelativeDateTime] should be relative to.
  final DateTime date;

  /// States whether to render using an `opacity` animation.
  final bool animateOpacity;

  /// The builder method returning the `child` widget.
  final Widget Function(RelativeDateTime relativeDateTime, String formatted)
  builder;

  /// Creates a [AnimatedRelativeDateTimeBuilder].

  const AnimatedRelativeDateBuilder({
    Key? key,
    required this.date,
    this.animateOpacity = false,
    required this.builder,
  }) : super(key: key);

  @override
  _AnimatedRelativeDateBuilderState createState() =>
      _AnimatedRelativeDateBuilderState();
}

class _AnimatedRelativeDateBuilderState
    extends State<AnimatedRelativeDateBuilder>
    with TickerProviderStateMixin {
  late AnimationController _tickerAnimationController;

  /// The animation's duration will be one second to sync the animation
  /// to the time ticker.
  final Duration _tickerDuration = const Duration(
    milliseconds: 1000,
  );

  /// Returns the animation opacity.
  ///
  /// Always returns `1` if no opacity animation is requested.
  double get _opacity {
    return widget.animateOpacity
        ? 0.35 + (_tickerAnimationController.value * 0.65)
        : 1.0;
  }

  @override
  void initState() {
    _tickerAnimationController = AnimationController(
      vsync: this,
      duration: _tickerDuration,
    );
    _tickerAnimationController.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _tickerAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _tickerAnimationController,
      builder: (context, _) {
        return _AnimatedDateChild(
          animationController: _tickerAnimationController,
          builder: widget.builder,
          date: widget.date,
          opacity: _opacity,
        );
      },
      child: _AnimatedDateChild(
        animationController: _tickerAnimationController,
        builder: widget.builder,
        date: widget.date,
        opacity: _opacity,
      ),
    );
  }
}

/// The child widget renderend either with or without an animated opacity.
class _AnimatedDateChild extends StatelessWidget {
  final double opacity;
  final AnimationController animationController;
  final DateTime date;
  final Widget Function(RelativeDateTime, String) builder;

  const _AnimatedDateChild({
    Key? key,
    required this.opacity,
    required this.animationController,
    required this.date,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return AnimatedOpacity(
      opacity: opacity,
      duration: animationController.duration!,
      child: RelativeDateTimeBuilder(
        date: DateTime(now.year, now.month, now.day),
        other: date,
        builder: (relDate, formatted) {
          return builder(relDate, formatted);
        },
      ),
    );
  }
}
