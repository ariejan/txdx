import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:txdx/utils/date_helper.dart';

void main() {
  group('date helpers', () {
    test('today', () {
      final now = DateTime(2014, 3, 29);
      withClock(Clock.fixed(now), () {
        expect(DateHelper.today(), equals(now));
      });
    });

    test('formattedDate', () {
      final datetime = DateTime(2014, 3, 2);
      final actual = DateHelper.formattedDate(datetime);

      expect(actual, equals('2014-03-02'));
    });

    test('futureDate', () {
      // These dates are picked because they are affected by DST
      final now = DateTime(2014, 3, 29);
      withClock(Clock.fixed(now), () {
        expect(DateHelper.futureDate(1), equals(DateTime(2014, 3, 30)));
        expect(DateHelper.futureDate(2), equals(DateTime(2014, 3, 31)));
        expect(DateHelper.futureDate(3), equals(DateTime(2014, 4, 1)));
      });
    });

    test('futureFormattedDate', () {
      final now = DateTime(2014, 3, 29);
      withClock(Clock.fixed(now), () {
        expect(DateHelper.futureFormattedDate(1), equals('2014-03-30'));
        expect(DateHelper.futureFormattedDate(2), equals('2014-03-31'));
        expect(DateHelper.futureFormattedDate(3), equals('2014-04-01'));
      });
    });

    test('futureWeekDate', () {
      final now = DateTime(2022, 5, 9); // A Monday
      withClock(Clock.fixed(now), () {
        expect(DateHelper.futureWeekDate(DateTime.tuesday), equals(DateTime(2022, 5, 10)));
        expect(DateHelper.futureWeekDate(DateTime.wednesday), equals(DateTime(2022, 5, 11)));
        expect(DateHelper.futureWeekDate(DateTime.thursday), equals(DateTime(2022, 5, 12)));
        expect(DateHelper.futureWeekDate(DateTime.friday), equals(DateTime(2022, 5, 13)));
        expect(DateHelper.futureWeekDate(DateTime.saturday), equals(DateTime(2022, 5, 14)));
        expect(DateHelper.futureWeekDate(DateTime.sunday), equals(DateTime(2022, 5, 15)));
        expect(DateHelper.futureWeekDate(DateTime.monday), equals(DateTime(2022, 5, 16)));
      });
    });
  });
}