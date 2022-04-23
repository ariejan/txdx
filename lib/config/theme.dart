import 'package:flutter/material.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';

import '../config/colors.dart';


abstract class TxDxTheme {
  static final _lightTheme = NordTheme.light();
  static final _darkTheme = NordTheme.dark();

  static ThemeData light() {
    return _lightTheme.copyWith(
      hoverColor: _lightTheme.highlightColor.withOpacity(0.1),
      highlightColor: _lightTheme.highlightColor.withOpacity(0.25),
      canvasColor: TxDxColors.lightBackground,
      appBarTheme: _darkTheme.appBarTheme.copyWith(
        backgroundColor: _lightTheme.primaryColorDark,
        shadowColor: Colors.transparent,
      ),
      listTileTheme: const ListTileThemeData(
        dense: true,
        visualDensity: VisualDensity.compact,
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        horizontalTitleGap: -12,
      ),
      scaffoldBackgroundColor: TxDxColors.lightBackground,
      colorScheme: _lightTheme.colorScheme.copyWith(
        background: TxDxColors.lightBackground,
      ),
      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
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
      hoverColor: _darkTheme.highlightColor.withOpacity(0.4),
      highlightColor: _darkTheme.highlightColor.withOpacity(0.6),

      canvasColor: TxDxColors.darkBackground,
      appBarTheme: _darkTheme.appBarTheme.copyWith(
        backgroundColor: _lightTheme.primaryColorDark,
        shadowColor: Colors.transparent,
      ),
      listTileTheme: const ListTileThemeData(
        dense: true,
        visualDensity: VisualDensity.compact,
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        horizontalTitleGap: -8,
      ),
      scaffoldBackgroundColor: TxDxColors.darkBackground,
      colorScheme: _darkTheme.colorScheme.copyWith(
        background: TxDxColors.darkBackground,

      ),
      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
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