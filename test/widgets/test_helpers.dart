import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestHelpers {
  static Widget wrapWidget(Widget widget) {
    return ProviderScope(
      child: MaterialApp(
          home: Material(
            child: widget,
          )
      )
    );
  }
}
