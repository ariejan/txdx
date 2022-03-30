import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:txdx/providers/settings_provider.dart';

class TestHelpers {
  static Future<Widget> wrapWidget(Widget widget) async {
    SharedPreferences.setMockInitialValues({}); //set values here
    SharedPreferences pref = await SharedPreferences.getInstance();

    return ProviderScope(
      overrides: [
        settingsProvider.overrideWithValue(Settings('test', pref)),
      ],
      child: MaterialApp(
          home: Material(
            child: widget,
          )
      )
    );
  }
}
