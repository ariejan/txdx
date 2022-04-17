
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/providers/items/contexts_provider.dart';

import '../../config/settings.dart';
import 'projects_provider.dart';

final filterProvider = Provider<Map<String, String>>((ref) {
  final theFilterItems = <String, String>{};
  theFilterItems.addAll(settingsDefaultFilterItems);

  final projects = ref.watch(projectsProvider);
  for (final project in projects) {
    theFilterItems[project] = project;
  }

  final contexts = ref.watch(contextsProvider);
  for (final context in contexts) {
    theFilterItems[context] = context;
  }

  return theFilterItems;
});