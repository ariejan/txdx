import 'package:flutter/material.dart';

class MenuHeaderWidget extends StatelessWidget {
  const MenuHeaderWidget(
      this.title, {
        this.subtitle,
        this.iconData,
        this.iconColor,
        this.fontSize,
        this.margin,
        this.actions = const [],
        Key? key,
      }) : super(key: key);

  final String title;
  final String? subtitle;
  final IconData? iconData;
  final Color? iconColor;
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (iconData != null) Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Icon(
                  iconData,
                  size: 28,
                  color: iconColor ?? Theme.of(context).textTheme.bodyText1?.color,
                ),
              ),
              Column(
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
                  if (subtitle != null) Text(
                    subtitle!,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: fontSize ?? 14,
                    ),
                  ),
                ],
              ),
              if (actions.isNotEmpty)
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: actions
                  ),
                )
            ],
          ),
        ]
      ),
    );
  }

}