import 'package:flutter/material.dart';

import '../../../config/colors.dart';

class SplitView extends StatelessWidget {
  const SplitView({
    Key? key,
    required this.sidebar,
    required this.content,
    this.sidebarWidth = 240,
  }) : super(key: key);

  final Widget sidebar;
  final Widget content;

  final double sidebarWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: sidebarWidth,
          child: sidebar,
        ),
        Container(width: 0.5, color: Theme.of(context).brightness == Brightness.light
            ? TxDxColors.lightEditBorder
            : TxDxColors.darkEditBorder,),
        Expanded(child: content),
      ],
    );
  }
}