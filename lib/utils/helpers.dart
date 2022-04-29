import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/filters.dart';
import '../config/settings.dart';
import '../providers/items/scoped_item_notifier.dart';
import '../providers/settings/settings_provider.dart';

class Helpers {
  static String getViewTitle(WidgetRef ref) {
    final filter = ref.read(itemFilter);
    final upcomingDays = ref.read(interfaceSettingsProvider).getInt(settingsUpcomingDays);

    switch (filter) {
      case null:
      case filterAll:
        return 'Everything';
      case filterToday:
        return 'Today';
      case filterUpcoming:
        return 'Next $upcomingDays days';
      case filterSomeday:
        return 'Someday';
      case filterOverdue:
        return 'Overdue';
      default:
        return filter!;
    }
  }
}