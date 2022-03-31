import 'package:flutter/material.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';

import '../config/colors.dart';


abstract class TxDxTheme {
  static final _lightTheme = NordTheme.light();
  static final _darkTheme = NordTheme.dark();

  static ThemeData light() {
    return _lightTheme.copyWith(
      canvasColor: TxDxColors.lightBackground,
      colorScheme: _lightTheme.colorScheme.copyWith(
        background: TxDxColors.lightBackground,
      ),
    );
  }

  static ThemeData dark() {
    return _darkTheme.copyWith(
      canvasColor: TxDxColors.darkBackground,
      colorScheme: _darkTheme.colorScheme.copyWith(
        background: TxDxColors.darkBackground,
      ),
    );
  }
}