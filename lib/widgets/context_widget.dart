
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContextWidget extends ConsumerWidget {
  const ContextWidget(
      this.contextText,
      {
        Key? key,
        this.color,
      }) : super(key: key);

  final String contextText;
  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(3),
        margin: const EdgeInsets.fromLTRB(3, 0, 3, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: color ?? Colors.blue,
        ),
        child: Text(
          contextText,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white,
          )
        ),
      ),
    );
  }
}