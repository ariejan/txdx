import 'package:flutter/material.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';

import '../config/colors.dart';


abstract class TxDxTheme {
  static final _lightTheme = NordTheme.light();
  static final _darkTheme = NordTheme.dark();

  static ThemeData light() {
    return _lightTheme.copyWith(
      hoverColor: Colors.transparent,
      highlightColor: NordColors.$9.withOpacity(0.25),
      canvasColor: TxDxColors.lightBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: NordColors.frost.darker,
        foregroundColor: Colors.white,
        shadowColor: Colors.transparent,
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4)
        ),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: NordColors.snowStorm.lightest,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: NordColors.frost.darkest,
        foregroundColor: Colors.white,
      ),
      navigationBarTheme: const NavigationBarThemeData(backgroundColor: Colors.red),
      listTileTheme: const ListTileThemeData(
        dense: true,
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
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
        isDense: true,
        filled: false,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
    );
  }

  static ThemeData dark() {
    return _darkTheme.copyWith(
      hoverColor: Colors.transparent,
      highlightColor: NordColors.$9.withOpacity(0.25),
      hintColor: NordColors.$5.withOpacity(0.8),
      canvasColor: TxDxColors.darkBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: NordColors.frost.darker,
        foregroundColor: Colors.white,
        shadowColor: Colors.transparent,
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4)
        ),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: NordColors.polarNight.darkest,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: NordColors.frost.darkest,
        foregroundColor: Colors.white,
      ),
      listTileTheme: const ListTileThemeData(
        dense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        horizontalTitleGap: -12,
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
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
        isDense: true,
        filled: false,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
    );
  }
}