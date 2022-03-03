
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/providers/item_notifier_provider.dart';

final projectsProvider = Provider<List<String>>((ref)  {
  final items = ref.watch(itemsNotifierProvider);
  final theSet = <String>{};
  for (var item in items) {
    theSet.addAll(item.projects);
  }
  return theSet.toList();

});