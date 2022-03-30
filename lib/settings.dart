const settingsFileTodoTxt = 'todotxt_filename';
const settingsFileArchiveTxt = 'archivetxt_filename';
const settingsFileAutoReload = 'file_autoreload';
const settingsThemeUseSystem = 'theme_system_brightness';
const settingsThemeUseDark = 'theme_use_dark';

const settingsUpcomingDays = 'filter_next_up_days';
const settingsTodayInUpcoming = 'filter_today_in_upcoming';
const settingsAutoAddFilter = 'item_auto_add_filter';


const defaultSettings = {
  settingsFileTodoTxt: null,
  settingsFileArchiveTxt: null,
  settingsFileAutoReload: true,
  settingsThemeUseSystem: true,
  settingsThemeUseDark: false,
  settingsUpcomingDays: 7,
  settingsAutoAddFilter: true,
  settingsTodayInUpcoming: true,
};

const nextUpDaysMin = 0;
const nextUpDaysMax = 90;