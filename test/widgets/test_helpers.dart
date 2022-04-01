import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:txdx/providers/settings/settings_provider.dart';

class TestHelpers {
  static Future<Widget> wrapWidget(
      Widget widget, { List<Override>? overrides = const [] }) async {

    SharedPreferences.setMockInitialValues({});
    SharedPreferences pref = await SharedPreferences.getInstance();

    List<Override> theOverrides = [
      settingsProvider.overrideWithValue(Settings('test', pref)),
    ];

    if (overrides != null) {
      theOverrides.addAll(overrides);
    }

    return ProviderScope(
        overrides: theOverrides,
        child: MaterialApp(
          home: Material(
            child: widget,
        )));
  }
}
