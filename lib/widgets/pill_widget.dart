
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PillWidget extends ConsumerWidget {
  const PillWidget(
      this.text,
      {
        Key? key,
        this.color,
      }) : super(key: key);

  final String text;
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
          text,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white,
          )
        ),
      ),
    );
  }
}