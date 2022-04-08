import 'filters.dart';

const settingsFileTodoTxt = 'todotxt_filename';
const settingsFileArchiveTxt = 'archivetxt_filename';
const settingsFileAutoReload = 'file_autoreload';
const settingsThemeUseSystem = 'theme_system_brightness';
const settingsThemeUseDark = 'theme_use_dark';

const settingsUpcomingDays = 'filter_next_up_days';
const settingsTodayInUpcoming = 'filter_today_in_upcoming';
const settingsDefaultFilter = 'filter_default_selection';

const settingsAutoAddFilter = 'item_auto_add_filter';

const settingsFileSaveOrdered = 'todotxt_file_save_ordered';

const settingsTodoTxtMacosSecureBookmark = 'todotxt_macos_secure_bookmark';
const settingsArchiveTxtMacosSecureBookmark = 'archivetxt_macos_secure_bookmark';

const defaultSettings = {
  settingsFileTodoTxt: null,
  settingsFileArchiveTxt: null,
  settingsFileAutoReload: true,
  settingsThemeUseSystem: true,
  settingsThemeUseDark: false,
  settingsUpcomingDays: 7,
  settingsAutoAddFilter: true,
  settingsTodayInUpcoming: true,
  settingsDefaultFilter: filterAll,
  settingsFileSaveOrdered: true,
};

const nextUpDaysMin = 0;
const nextUpDaysMax = 90;

const settingsDefaultFilterItems = {
  filterAll: 'Everything',
  filterToday: 'Today',
  filterUpcoming: 'Upcoming',
  filterSomeday: 'Someday',
  filterOverdue: 'Overdue',
};