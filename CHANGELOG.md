# Changelog
All notable changes to this project will be documented in this file.

## [1.0.14] - 2022-04-19
### Added
- Default filter can now also be a context or project. [#86]
- (macOS) Set filter to use for dock badge count. [#87]
- Add setting and in-view option to select item sorting. [#90]
### Fixed
- Search does not match case for easier finding. [#91]
- Cannot select light theme from settings. [#97]
### Changed
- Swap order of projects and contexts in the sidebar. [#92]

## [1.0.13] - 2022-04-17
### Added
- TxDx's uses folder-based storage now. [#82]
- Automatically setup todox.txt and archive.txt for new users. [#76]
- Add counters to all filters, contexts and projects. [#84]
### Fixed
- Make theme selection more intuitive. [#85]
- Open the file picker in user documents by default. [#83]

## [1.0.12] - 2022-04-12
### Fixed
- Fixed start-up issue when no user preferences are available. [#78]

## [1.0.11] - 2022-04-11
### Added
- Handle `due:fri` and `due:sunday` due date helpers. [#74]
### Fixed
- Improve selecting next item on toggle complete / delete. [#26]
- Misc. bug fixes

## [1.0.10] - 2022-04-10
### Added
- Show number of items in under each filter. [#72]
- Show dock badge for today's items on macOS. [#73]
- Add a helpful welcome screen for new users. [#54]
### Fixed
- Sort projects/context alphabetically. [#71]

## [1.0.9] - 2022-04-07
### Added
- Enable Sandbox mode on macos for App Store/Notarized release [#66]
### Fixed
- Make setings screen more usable [#69]
- Link to correct website [#67]

## [1.0.8] - 2022-04-02
### Added
- Add option to sort items when writing to file. [#29]
- Add search/filter through cmd-f. [#64]
- Handle future due dates: due:1y2m3w4d format. [#63]
### Fixed
- Fix dueOn words calculation. [#65]

## [1.0.7] - 2022-03-30
### Added
- Item context menu (right click) for quick item tasks [#62]
- Add setting for the default item filter on start-up [#56]

## [1.0.6] - 2022-03-29
### Added
- Refactored the Upcoming and Someday filtered views [#55]
- Automatically add due:today, project or context if a filter is selected. [#39]
### Fixed
- Fixed off-by-one issue with relative time for due dates.

## [1.0.5] - 2022-03-28
### Fixed
- Misc. improvements and fixes

## [1.0.4] - 2022-03-27
### Fixed
- Fixed correct scrolling behavior for sidebar and item list [#32]

## [1.0.3] - 2022-03-26
### Added
- Add settings for system/light/dark theme mode [#38]
- Add cmd-t shortcut to move the selected item to 'due:today' [#41]

## [1.0.2] - 2022-03-25
### Added
- Detect file changes in todo.txt and offer to reload [#12]
- Added setting to auto reload when todo.txt changes [#12]
- Do not show contexts/projects in sidebar if there are none. [#34]
- Add cmd-up/cmd-down to change the priority of the selected item. [#33]

## [1.0.1] - 2022-03-23
### Changed
- Update color scheme for better contrast
- Keep focus on new item input field after adding an item [#30]

## [1.0.0] - 2022-03-22
### Added
- Initial release of TxDx
- Read and manage todo items from a Todo.txt file
- Filter items on due date, context or project
- Archive completed items to a separate Archive.txt file
- Handle 'human input' due dates, like `due:tomorrow`
