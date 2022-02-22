

import 'package:flutter/material.dart';

class GroupHeaderWidget extends StatelessWidget {
  const GroupHeaderWidget(
      this.groupName,
      {Key? key}) : super(key: key);

  final String groupName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            groupName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )
          ),
          const Divider(),
        ],
      )
    );
  }

}