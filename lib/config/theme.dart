import 'package:flutter/material.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';

import '../config/colors.dart';


abstract class TxDxTheme {
  static final _lightTheme = NordTheme.light();
  static final _darkTheme = NordTheme.dark();

  static ThemeData light() {
    return _lightTheme.copyWith(
      canvasColor: TxDxColors.lightBackground,
      appBarTheme: _darkTheme.appBarTheme.copyWith(
        backgroundColor: _lightTheme.primaryColorDark,
        shadowColor: Colors.transparent,
      ),
      scaffoldBackgroundColor: TxDxColors.lightBackground,
      colorScheme: _lightTheme.colorScheme.copyWith(
        background: TxDxColors.lightBackground,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: _lightTheme.disabledColor,
          backgroundColor: Colors.transparent,
          animationDuration: Duration.zero,
        ),
      ),
    );
  }

  static ThemeData dark() {
    return _darkTheme.copyWith(
      canvasColor: TxDxColors.darkBackground,
      appBarTheme: _darkTheme.appBarTheme.copyWith(
        backgroundColor: _lightTheme.primaryColorDark,
        shadowColor: Colors.transparent,
      ),
      scaffoldBackgroundColor: TxDxColors.darkBackground,
      colorScheme: _darkTheme.colorScheme.copyWith(
        background: TxDxColors.darkBackground,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: _darkTheme.disabledColor,
          backgroundColor: Colors.transparent,
          animationDuration: Duration.zero,
        ),
      ),
    );
  }
}