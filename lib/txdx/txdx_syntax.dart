import 'package:jiffy/jiffy.dart';
import 'package:clock/clock.dart';

import '../utils/date_helper.dart';

class TxDxSyntax {
  static RegExp contextsRegExp = RegExp(r'(?:\s+|^)@[^\s]+');
  static RegExp projectsRegExp = RegExp(r'(?:\s+|^)\+[^\s]+');
  static RegExp priorityRegExp = RegExp(r'(?:^|\s+)\(([A-Za-z])\)\s+');
  static RegExp createdOnRegExp = RegExp(r'(?:^|-\d{2}\s|\)\s)(\d{4}-\d{2}-\d{2})\s');
  static RegExp completedOnRegExp = RegExp(r'^x\s+(\d{4}-\d{2}-\d{2})\s+');
  static RegExp completedRegExp = RegExp(r'^x\s+');
  static RegExp tagsRegExp = RegExp(r'([a-z]+):([\+?A-Za-z0-9_-]+)', caseSensitive: false);

  static RegExp incDaysRegExp = RegExp(r'(\d+y)?(\d+m)?(\d+w)?(\d+d)?');
  static RegExp todoTxtDate = RegExp(r'(\d{4}-\d{1,2}-\d{1,2})');

  static bool getCompleted(String text) {
    return _getMatch(completedRegExp, text) != null;
  }

  static String getDescription(String text) {
    return _replaceEverything(text);
  }

  static String? getPriority(String text) {
    return _getMatch(priorityRegExp, text);
  }

  static DateTime? getCreatedOn(String text) {
    return _getDate(createdOnRegExp, text);
  }

  static DateTime? getCompletedOn(String text) {
    return _getDate(completedOnRegExp, text);
  }

  static Map<String, String> getTags(String text) {
    final tags = _getMatchedPairs(tagsRegExp, text);



    // Find/replace the 'due' tag if it exists.
    if (tags.containsKey('due')) {
      final value = tags['due']!.toLowerCase();


      if (todoTxtDate.hasMatch(value)) {
        tags['due'] = Jiffy(value).format('yyyy-MM-dd');
      } else if (value == 'today') {
        tags['due'] = DateHelper.futureFormattedDate(0);
      } else if (value == 'tomorrow') {
        tags['due'] = DateHelper.futureFormattedDate(1);
      } else if (value == 'yesterday') {
        tags['due'] = DateHelper.futureFormattedDate(-1);
      } else if (value == 'mon' || value == 'monday') {
        tags['due'] = DateHelper.futureFormattedWeekDate(DateTime.monday);
      } else if (value == 'tue' || value == 'tuesday') {
        tags['due'] = DateHelper.futureFormattedWeekDate(DateTime.tuesday);
      } else if (value == 'wed' || value == 'wednesday') {
        tags['due'] = DateHelper.futureFormattedWeekDate(DateTime.wednesday);
      } else if (value == 'thu' || value == 'thursday') {
        tags['due'] = DateHelper.futureFormattedWeekDate(DateTime.thursday);
      } else if (value == 'fri' || value == 'friday') {
        tags['due'] = DateHelper.futureFormattedWeekDate(DateTime.friday);
      } else if (value == 'sat' || value == 'saturday') {
        tags['due'] = DateHelper.futureFormattedWeekDate(DateTime.saturday);
      } else if (value == 'sun' || value == 'sunday') {
        tags['due'] = DateHelper.futureFormattedWeekDate(DateTime.sunday);
      } else {
        var match = incDaysRegExp.firstMatch(value);
        if (match != null) {
          var dueOn = clock.now();
          final yearVal = match.group(1);
          final monthVal = match.group(2);
          final weekVal = match.group(3);
          final dayVal = match.group(4);

          if (yearVal != null) {
            final value = int.parse(yearVal.substring(0, yearVal.length - 1));
            dueOn = Jiffy(dueOn).add(years: value).dateTime;
          }
          if (monthVal != null) {
            final value = int.parse(monthVal.substring(0, monthVal.length - 1));
            dueOn = Jiffy(dueOn).add(months: value).dateTime;
          }
          if (weekVal != null) {
            final value = int.parse(weekVal.substring(0, weekVal.length - 1));
            dueOn = Jiffy(dueOn).add(weeks: value).dateTime;
          }
          if (dayVal != null) {
            final value = int.parse(dayVal.substring(0, dayVal.length - 1));
            dueOn = Jiffy(dueOn).add(days: value).dateTime;
          }

          tags['due'] = DateHelper.formattedDate(dueOn);
        }
      }
    }


    return tags;
  }

  static Iterable<String> getContexts(String text) {
    return _getMatches(contextsRegExp, text);
  }

  static Iterable<String> getProjects(String text) {
    return _getMatches(projectsRegExp, text);
  }

  static String _replaceEverything(String text) {
    return text.replaceAll(completedOnRegExp, '')
        .replaceAll(completedRegExp, '')
        .replaceAll(priorityRegExp, '')
        .replaceAll(contextsRegExp, '')
        .replaceAll(projectsRegExp, '')
        .replaceAll(tagsRegExp, '')
        .replaceAll(createdOnRegExp, '')
        .trim();
  }

  static Iterable<String> _getMatches(RegExp regExp, String text) {
    Iterable<RegExpMatch> matches = regExp.allMatches(text);
    return matches.map((e) => e.group(0).toString().trim()).toList();
  }

  static String? _getMatch(RegExp regExp, String text) {
    String? match = regExp.stringMatch(text);
    return (match != null) ? match[1] : null;
  }

  static DateTime? _getDate(RegExp regExp, String text) {
    RegExpMatch? match = regExp.firstMatch(text);
    if (match == null) return null;

    String? matchedDate = match.group(1);
    if (matchedDate == null) return null;

    return DateTime.tryParse(matchedDate.trim());
  }

  static Map<String, String> _getMatchedPairs(RegExp regExp, String text) {
    Iterable<RegExpMatch> matches = regExp.allMatches(text);
    Map<String, String> results = <String, String>{};

    for (var match in matches) {
      String pair = match.group(0).toString().trim();
      List<String> keyVal = pair.split(':');
      results[keyVal[0].toLowerCase()] = keyVal[1];
    }

    return results;
  }
}