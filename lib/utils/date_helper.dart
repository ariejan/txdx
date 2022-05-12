import 'package:clock/clock.dart';
import 'package:jiffy/jiffy.dart';

class DateHelper {

  static DateTime today() {
    final now = clock.now();
    return DateTime(now.year, now.month, now.day);
  }

  // Formats a DateTime to yyyy-MM-dd format
  static String formattedDate(DateTime dateTime) {
    return Jiffy(dateTime).format('yyyy-MM-dd');
  }

  // Returns a yyyy-MM-dd string for a date n days in the future
  static String futureFormattedDate(int n) {
    return formattedDate(futureDate(n));
  }

  // Returns a DateTime n days in the future
  static DateTime futureDate(int n) {
    return DateTime(today().year, today().month, today().day + n);
  }

  // Returns a yyyy-MM-dd string for the next weekday occurrence
  static String futureFormattedWeekDate(int weekDay) {
    return formattedDate(futureWeekDate(weekDay));
  }

  // Returns a DateTime for the next weekday occurrence
  static DateTime futureWeekDate(int weekDay) {
    final now = today();
    final nowWd = now.weekday;
    var dayDelta = (nowWd < weekDay)
        ? weekDay - nowWd
        : (weekDay + 7) - nowWd;
    return futureDate(dayDelta);
  }
}