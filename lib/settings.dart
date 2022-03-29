const settingsFileTodoTxt = 'todotxt_filename';
const settingsFileArchiveTxt = 'archivetxt_filename';
const settingsFileAutoReload = 'file_autoreload';
const settingsThemeUseSystem = 'theme_system_brightness';
const settingsThemeUseDark = 'theme_use_dark';
const settingsNextUpDays = 'filter_next_up_days';

const defaultSettings = {
  settingsFileTodoTxt: null,
  settingsFileArchiveTxt: null,
  settingsFileAutoReload: true,
  settingsThemeUseSystem: true,
  settingsThemeUseDark: false,
  settingsNextUpDays: 7,
};

const nextUpDaysMin = 0;
const nextUpDaysMax = 90;