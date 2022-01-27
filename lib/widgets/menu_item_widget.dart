import 'package:flutter/material.dart';

class MenuItemWidget extends StatelessWidget {
  const MenuItemWidget({
    Key? key,
    this.icon,
    this.indicatorColor,
    required this.title,
    this.onTap,
  }) : super(key: key);

  final Widget? icon;
  final Color? indicatorColor;
  final Widget title;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(6, 3, 6, 3),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: icon ?? Container(
                width: 16,
                height: 16,
                color: indicatorColor ?? Colors.blue,
              )
              ,
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: title,
            ),
          ]
        ),
      ),
    );
  }
}