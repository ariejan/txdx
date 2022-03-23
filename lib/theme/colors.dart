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

  static const Color lightBackground = Color(0xffFFFFFF);
  static const Color darkBackground = Color(0xff1E1E1E);

  static final Color lightSelection = NordColors.$3.withAlpha(50);
  static final Color darkSelection = NordColors.$3.withAlpha(70);

  static final Color prioA = NordColors.aurora.red;
  static final Color prioB = NordColors.aurora.orange;
  static final Color prioC = NordColors.aurora.yellow;
  static final Color prioD = NordColors.aurora.green;
  static const Color prioDefault = NordColors.$9;

  static final Color dueOnToday = NordColors.aurora.green;
  static final Color dueOnOverdue = NordColors.aurora.red;
  static final Color dueOn = NordColors.frost.darker;

  static final Color linkText = NordColors.frost.darkest;

  static final Color projects = NordColors.aurora.green;
  static final Color contexts = NordColors.aurora.orange;
  static final Color tags = NordColors.frost.darkest;
}