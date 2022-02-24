import 'package:flutter/material.dart';

import 'pill_widget.dart';

class ItemTagWidget extends StatelessWidget {

  final String name;
  final String? value;

  const ItemTagWidget({Key? key, required this.name, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PillWidget(
      '$name:$value',
      color: Colors.blue.shade600,
    );
  }
}