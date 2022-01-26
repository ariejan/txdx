import 'package:flutter/material.dart';

class TestHelpers {
  static Widget wrapWidget(Widget widget) {
    return MaterialApp(
        home: Material(
          child: widget,
        )
    );
  }
}
