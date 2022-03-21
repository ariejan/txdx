import 'package:jiffy/jiffy.dart';

class TxDxSyntax {
  static RegExp contextsRegExp = RegExp(r'(?:\s+|^)@[^\s]+');
  static RegExp projectsRegExp = RegExp(r'(?:\s+|^)\+[^\s]+');
  static RegExp priorityRegExp = RegExp(r'(?:^|\s+)\(([A-Za-z])\)\s+');
  static RegExp createdOnRegExp = RegExp(r'(?:^|-\d{2}\s|\)\s)(\d{4}-\d{2}-\d{2})\s');
  static RegExp completedOnRegExp = RegExp(r'^x\s+(\d{4}-\d{2}-\d{2})\s+');
  static RegExp completedRegExp = RegExp(r'^x\s+');
  static RegExp tagsRegExp = RegExp(r'([a-z]+):([\+?A-Za-z0-9_-]+)', caseSensitive: false);

  static RegExp incDaysRegExp = RegExp(r'^\+(\d+)');

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

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = DateTime(now.year, now.month, now.day + 1);
      final yesterday = DateTime(now.year, now.month, now.day - 1);

      DateTime? dueOn;

      final matchResult = _getMatch(incDaysRegExp, value);

      if (matchResult != null) {
        dueOn = now.add(Duration(days: int.parse(matchResult)));
      } else {
        switch (value) {
          case 'today':
            dueOn = today;
            break;
          case 'tomorrow':
            dueOn = tomorrow;
            break;
          case 'yesterday':
            dueOn = yesterday;
            break;
          default:
            dueOn = Jiffy(value).dateTime;
        }
      }

      tags['due'] = Jiffy(dueOn).format('yyyy-MM-dd');
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