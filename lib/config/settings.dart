import 'package:txdx/providers/items/scoped_item_notifier.dart';

import 'filters.dart';

const settingsTxDxDirectory = 'txdx_directory';
const settingsTxDxDirectoryMacosSecureBookmark = 'txdx_directory_macos_secure_bookmark';

const settingsFileTodoTxt = 'txdx_todotxt_filename';
const settingsFileArchiveTxt = 'txdx_archivetxt_filename';
const settingsFileAutoReload = 'file_autoreload';

const settingsThemeBrightness = 'theme_brightness';

const settingsUpcomingDays = 'filter_next_up_days';
const settingsTodayInUpcoming = 'filter_today_in_upcoming';
const settingsDefaultFilter = 'filter_default_selection';
const settingsDefaultSorting = 'items_default_sorting';
const settingsFilterMacosBadgeCount = 'filter_macos_badge_count';

const settingsAutoAddFilter = 'item_auto_add_filter';

const settingsFileSaveOrdered = 'todotxt_file_save_ordered';

const settingsTodoTxtMacosSecureBookmark = 'todotxt_macos_secure_bookmark';
const settingsArchiveTxtMacosSecureBookmark = 'archivetxt_macos_secure_bookmark';

const defaultSettings = {
  settingsFileTodoTxt: 'todo.txt',
  settingsFileArchiveTxt: 'archive.txt',
  settingsFileAutoReload: true,
  settingsThemeBrightness: 'system',
  settingsUpcomingDays: 7,
  settingsAutoAddFilter: true,
  settingsTodayInUpcoming: true,
  settingsDefaultFilter: filterAll,
  settingsFileSaveOrdered: true,
  settingsFilterMacosBadgeCount: filterToday,
  settingsDefaultSorting: ItemStateSorter.priority,
};

const nextUpDaysMin = 0;
const nextUpDaysMax = 90;

const settingsThemeBrightnessOptions = {
  'system': 'Use system setting',
  'dark': 'Dark theme',
  'light': 'Light theme',
};

const settingsDefaultFilterItems = {
  filterAll: 'Everything',
  filterToday: 'Today',
  filterUpcoming: 'Upcoming',
  filterSomeday: 'Someday',
  filterOverdue: 'Overdue',
};

const settingsSortOrders = {
  ItemStateSorter.priority: 'Priority',
  ItemStateSorter.dueOn: 'Due date',
};