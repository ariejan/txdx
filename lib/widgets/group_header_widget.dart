

import 'package:flutter/material.dart';

class GroupHeaderWidget extends StatelessWidget {
  const GroupHeaderWidget(
      this.groupName,
      {Key? key}) : super(key: key);

  final String groupName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Text(
        groupName,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        )
      )
    );
  }

}