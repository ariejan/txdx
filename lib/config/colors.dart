import 'package:flutter/material.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';

abstract class TxDxColors {
  static Color forPriority(String? prio) {
    switch (prio) {
      case 'A': return prioA;
      case 'B': return prioB;
      case 'C': return prioC;
      case 'D': return prioD;
      default: return prioDefault;
    }
  }

  static final Color buttonPrimary = NordColors.frost.darkest;

  static const Color lightBackground = Color(0xffFFFFFF);
  static const Color darkBackground = Color(0xff1E1E1E);

  static final Color lightEditBorder = NordColors.$4.withOpacity(0.7);
  static const Color lightEditShadow = NordColors.$4;

  static final Color darkEditBorder = NordColors.$1.withOpacity(0.7);
  static const Color darkEditShadow = NordColors.$1;

  static final Color lightSelection = NordColors.$3.withAlpha(50);
  static final Color darkSelection = NordColors.$3.withAlpha(70);

  static final Color prioA = NordColors.aurora.red;
  static final Color prioB = NordColors.aurora.orange;
  static final Color prioC = NordColors.aurora.yellow;
  static final Color prioD = NordColors.aurora.green;
  static const Color prioDefault = NordColors.$9;

  static final Color lightCheckbox = NordColors.$3.withOpacity(0.4);
  static final Color lightCheckboxHover = NordColors.$3.withOpacity(0.8);
  static final Color darkCheckbox = NordColors.$3.withOpacity(0.4);
  static final Color darkCheckboxHover = NordColors.$3.withOpacity(0.8);

  static final Color dueOnToday = NordColors.aurora.red;

  static final Color linkText = NordColors.frost.darkest;

  static final Color projects = NordColors.aurora.green;
  static final Color contexts = NordColors.aurora.orange;
  static final Color tags = NordColors.frost.darkest;

  static final Color banner = NordColors.frost.darker.withOpacity(0.4);

  static final Color lightContextBackgroundColor = lightSelection;
  static final Color lightContextHoverColor = lightSelection.withAlpha(50);
  static final Color darkContextBackgroundColor = darkBackground.withAlpha(20);
  static final Color darkContextHoverColor = darkBackground.withOpacity(0.5);

  static final Color lightBadge = NordColors.snowStorm.darkest;
  static final Color lightBadge2 = NordColors.snowStorm.lightest;

  static final Color darkBadge = NordColors.frost.darkest;
  static final Color darkBadge2 = NordColors.polarNight.lighter;

  static const Color txdxPurple = Color(0xFF5215cb);
  static const Color txdxPink = Color(0xFFe923ac);
  static const Color txdxOrange = Color(0xFFe5bf77);

  static Gradient txdxGradient() {
    return const LinearGradient(
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      colors: [txdxPurple, txdxPink, txdxOrange],
      stops: [0.0, 0.5, 1.0],
    );
  }
}