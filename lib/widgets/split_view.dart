import 'package:flutter/material.dart';

class SplitView extends StatelessWidget {
  const SplitView({
    Key? key,
    required this.sidebar,
    required this.content,
    required this.editor,
    this.sidebarWidth = 240,
    this.editorWidth = 240,
    this.showEditor = true,
  }) : super(key: key);

  final Widget sidebar;
  final Widget content;
  final Widget editor;

  final double sidebarWidth;
  final double editorWidth;

  final bool showEditor;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Row(
      children: [
        SizedBox(
          width: sidebarWidth,
          child: sidebar,
        ),
        Container(width: 0.5, color: Colors.black),
        Expanded(child: content),
        if (showEditor)
          Container(width: 0.5, color: Colors.black),
        if (showEditor)
          SizedBox(
            width: editorWidth,
            child: editor,
          ),
      ],
    );
  }
}