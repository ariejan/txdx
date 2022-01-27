
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/providers/item_notifier_provider.dart';

final projectsProvider = Provider<AsyncValue<List<String>>>((ref)  {
  final asyncItems = ref.watch(itemsNotifierProvider);

  return asyncItems.whenData((items) {
    final theSet = <String>{};
    for (var item in items) {
      theSet.addAll(item.projects);
    }
    return theSet.toList();
  });
});