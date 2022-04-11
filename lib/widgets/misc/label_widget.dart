import 'package:flutter/material.dart';

class LabelWidget extends StatelessWidget {
  const LabelWidget(
    this.text,
    {
      Key? key,
      this.color,
      this.fontSize
  }) : super(key: key);

  final String text;
  final Color? color;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 6, 0),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: fontSize ?? 12,
        ),
      ),
    );
  }
}