class TxDxSyntax {
  static RegExp contextsRegExp = RegExp(r'(?:\s+|^)@[^\s]+');
  static RegExp projectsRegExp = RegExp(r'(?:\s+|^)\+[^\s]+');
  static RegExp priorityRegExp = RegExp(r'(?:^|\s+)\(([A-Za-z])\)\s+');
  static RegExp createdOnRegExp = RegExp(r'(?:^|-\d{2}\s|\)\s)(\d{4}-\d{2}-\d{2})\s');
  static RegExp completedOnRegExp = RegExp(r'^x\s+(\d{4}-\d{2}-\d{2})\s+');
  static RegExp completedRegExp = RegExp(r'^x\s+');
  static RegExp dueOnRegExp = RegExp(r'(?:due:)(\d{4}-\d{2}-\d{2})(?:\s+|$)', caseSensitive: false);
  static RegExp tagsRegExp = RegExp(r'([a-z]+):([A-Za-z0-9_-]+)', caseSensitive: false);

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

  static DateTime? getDueOn(String text) {
    return _getDate(dueOnRegExp, text);
  }

  static Map<String, String> getTags(String text) {
    final tags = _getMatchedPairs(tagsRegExp, text);
    tags.removeWhere((key, value) => key == 'due');
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
        .replaceAll(dueOnRegExp, '')
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
      results[keyVal[0]] = keyVal[1];
    }

    return results;
  }
}