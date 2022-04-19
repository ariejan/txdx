import 'package:flutter/material.dart';

class MenuHeaderWidget extends StatelessWidget {
  const MenuHeaderWidget(
      this.title, {
        this.fontSize,
        this.margin,
        this.actions = const [],
        Key? key,
      }) : super(key: key);

  final String title;
  final double? fontSize;
  final EdgeInsetsGeometry? margin;

  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: fontSize ?? 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (actions.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions
                )
            ],
          ),
          const Divider(),
        ]
      ),
    );
  }

}