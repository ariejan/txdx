import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../config/shortcuts.dart';
import '../providers/items/scoped_item_notifier.dart';
import '../providers/items/selected_item_provider.dart';

class CancelSearchAndEditAction extends Action<CancelActionIntent> {

  final WidgetRef ref;

  CancelSearchAndEditAction(this.ref);

  @override
  Object? invoke(CancelActionIntent intent) {
    if (ref.read(isSearchingProvider)) {
      ref.read(searchTextProvider.state).state = null;
      ref.read(isSearchingProvider.state).state = false;
    } else {
      ref.read(editingItemIdStateProvider.state).state = null;
    }

    return null;
  }
}