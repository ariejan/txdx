
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:txdx/providers/items/item_notifier_provider.dart';
import 'package:txdx/txdx/txdx_item.dart';
import 'package:txdx/utils/date_helper.dart';

import '../../../config/settings.dart';
import '../../../providers/settings/settings_provider.dart';
import '../context/context_menu.dart';
import '../context/context_menu_item.dart';

class DueOnPicker extends ConsumerStatefulWidget {

  final TxDxItem item;
  final TextEditingController controller;
  final FocusNode parentFocusNode;

  const DueOnPicker(this.item, this.controller, this.parentFocusNode, {Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DueOnPickerState();
}

class _DueOnPickerState extends ConsumerState<DueOnPicker> {
  bool isHovering = false;

  final dueOnTextDefault = "No due date set";
  String dueOnText = '';

  void _setDueOn(DateTime? dueOn) {
    if (dueOn != null) {
      final strDueOn = Jiffy(dueOn).format('yyyy-MM-dd');

      widget.controller.text = strDueOn;
      setState(() => dueOnText = strDueOn);
    } else {
      widget.controller.text = '';
      setState(() => dueOnText = dueOnTextDefault);
    }

    widget.parentFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {

    final settingWeeksStartOn = ref.watch(interfaceSettingsProvider).getString(settingsWeeksStartsOn);

    if (dueOnText.isEmpty) {
      _setDueOn(widget.item.dueOn);
    }

    return InkWell(
      mouseCursor: MouseCursor.defer,
      onTap: () {},
      onHover: (hovering) {
        setState(() => isHovering = hovering);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 6, 0),
        child: Row(
          children: [
            if (!isHovering) Padding(
              padding: const EdgeInsets.fromLTRB(0, 2, 4, 0),
              child: Icon(
                  Icons.flag_sharp,
                  size: 14,
                  color: Theme.of(context).hintColor
              ),
            ),
            if (isHovering) GestureDetector(
              onTap: () {
                _setDueOn(null);
              },
              child: const Padding(
                padding: EdgeInsets.fromLTRB(0, 2, 4, 0),
                child: Icon(
                  Icons.clear_sharp,
                  size: 14,
                ),
              ),
            ),
            GestureDetector(
              onTapDown: (details) async {
                showModal(
                  context: context,
                  configuration: FadeScaleTransitionConfiguration(
                    barrierColor: Colors.transparent,
                  ),
                  builder: (context) => ContextMenu(
                    position: details.globalPosition,
                    children: [
                      ListTile(
                        title: Text('Select a due date', style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        )),
                        dense: true,
                      ),
                      ContextMenuItem(
                        title: 'Today',
                        onTap: () {
                          Navigator.pop(context);
                          _setDueOn(DateHelper.today());
                        },
                      ),
                      ContextMenuItem(
                        title: 'Tomorrow',
                        onTap: () {
                          Navigator.pop(context);
                          _setDueOn(DateHelper.futureDate(1));
                        },
                      ),
                      ContextMenuItem(
                        title: 'This weekend',
                        onTap: () {
                          Navigator.pop(context);
                          _setDueOn(DateHelper.futureWeekDate(DateTime.saturday));
                        },
                      ),
                      ContextMenuItem(
                        title: 'Next week',
                        onTap: () {
                          Navigator.pop(context);
                          _setDueOn(DateHelper.futureWeekDate(DateTime.monday));
                        },
                      ),
                      ContextMenuItem(
                        title: 'Pick a date',
                        onTap: () {
                          Navigator.pop(context);
                          buildShowDatePicker(context, settingWeeksStartOn).then((pickedDate) {
                            if (pickedDate != null) {
                              _setDueOn(pickedDate);
                            }
                          });
                        },
                      ),
                    ],
                    verticalPadding: 8,
                    width: 240,
                  )
                );
              },
              onDoubleTap: () async {
                buildShowDatePicker(context, settingWeeksStartOn).then((pickedDate) {
                  if (pickedDate != null) {
                    _setDueOn(pickedDate);
                  }
                });
              },
              child: Text(
                dueOnText,
                style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<DateTime?> buildShowDatePicker(BuildContext context, String? settingWeeksStartOn) {
    return showDatePicker(
                context: context,
                locale: settingWeeksStartOn == 'monday' ? const Locale('en', 'GB') : const Locale('en', 'US'),
                initialDate: widget.item.dueOn ?? DateTime.now(),
                firstDate: DateTime(1970, 1, 1),
                lastDate: DateTime(2099, 12, 31),
                initialEntryMode: DatePickerEntryMode.calendarOnly,
                helpText: 'Due on',
              );
  }

}