import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/config/shortcuts.dart';

class UnarchiveItemAction extends Action<UnarchiveItemIntent> {

  final WidgetRef ref;

  UnarchiveItemAction(this.ref);

  @override
  Object? invoke(UnarchiveItemIntent intent) {
    // TODO: Implement unarchive
  }
}