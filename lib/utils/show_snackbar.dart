import 'package:flutter/material.dart';

import '../config/colors.dart';

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    backgroundColor: TxDxColors.buttonPrimary,
    duration: const Duration(milliseconds: 1000),
    behavior: SnackBarBehavior.floating,

  ));
}