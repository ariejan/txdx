import 'package:flutter/material.dart';

class MenuHeaderWidget extends StatelessWidget {
  const MenuHeaderWidget(
      this.title, {
        this.fontSize,
        this.margin,
        Key? key
      }) : super(key: key);

  final String title;
  final double? fontSize;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: fontSize ?? 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
        ]
      ),
    );
  }

}