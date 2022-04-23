
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PillWidget extends ConsumerWidget {
  const PillWidget(
      this.text,
      {
        Key? key,
        this.color,
        this.backgroundColor,
        this.fontSize,
      }) : super(key: key);

  final String text;
  final Color? color;
  final Color? backgroundColor;
  final double? fontSize;

  Color _getColor(Color color) {
    Color result = Colors.white38;

    if (color.alpha > 0) {
      double luminance =
          (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;

      if (luminance > 0.5) {
        result = Colors.black.withAlpha(color.alpha);
      } else {
        result = Colors.black.withAlpha(color.alpha);
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bgColor = backgroundColor ?? Colors.transparent;
    final fgColor = color ?? _getColor(bgColor);

    return Container(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      margin: const EdgeInsets.fromLTRB(2, 0, 2, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: bgColor,
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize ?? 12,
          color: fgColor,
        )
      ),
    );
  }
}