# Changelog
All notable changes to this project will be documented in this file.

## [Unreleased]

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
