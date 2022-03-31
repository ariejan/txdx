import 'package:flutter/material.dart';

import '../misc/pill_widget.dart';

class ItemTagWidget extends StatelessWidget {

  final String name;
  final String? value;
  final Color? color;

  const ItemTagWidget({
    Key? key,
    required this.name,
    this.value,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PillWidget(
      '$name:$value',
      color: color ?? Theme.of(context).primaryColor,
    );
  }
}