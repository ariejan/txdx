import 'package:flutter/material.dart';

class LabelWidget extends StatelessWidget {
  const LabelWidget(
    this.text,
    {
      Key? key,
      this.color,
      this.fontSize,
      this.iconData,
  }) : super(key: key);

  final String text;
  final Color? color;
  final double? fontSize;
  final IconData? iconData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 6, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (iconData != null) Padding(
            padding: const EdgeInsets.fromLTRB(0, 2, 4, 0),
            child: Icon(
              iconData!,
              size: 14,
              color: color,
            ),
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize ?? 12,
              color: Theme.of(context).hintColor
            ),
          ),
        ],
      ),
    );
  }
}