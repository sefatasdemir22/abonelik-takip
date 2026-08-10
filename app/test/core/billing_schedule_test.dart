import 'package:abonelik_takip/core/domain/billing_schedule.dart';
import 'package:abonelik_takip/core/domain/local_date.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BillingSchedule monthly', () {
    test('normal tarihte sonraki aya ayni anchor day ile gecer', () {
      final schedule = BillingSchedule.monthly(day: 15);

      expect(
        schedule.nextAfter(LocalDate(2026, 1, 15)),
        LocalDate(2026, 2, 15),
      );
    });

    test('day 31 January sonrasi February sonuna clamp edilir', () {
      final schedule = BillingSchedule.monthly(day: 31);

      expect(
        schedule.nextAfter(LocalDate(2025, 1, 31)),
        LocalDate(2025, 2, 28),
      );
    });

    test('day 31 February clamp sonrasi March 31 olarak geri doner', () {
      final schedule = BillingSchedule.monthly(day: 31);

      expect(
        schedule.nextAfter(LocalDate(2025, 2, 28)),
        LocalDate(2025, 3, 31),
      );
    });

    test('gecersiz day reddedilir', () {
      expect(() => BillingSchedule.monthly(day: 0), throwsArgumentError);
      expect(() => BillingSchedule.monthly(day: 32), throwsArgumentError);
    });
  });

  group('BillingSchedule yearly', () {
    test('normal tarihte sonraki yila ayni anchor ile gecer', () {
      final schedule = BillingSchedule.yearly(month: 6, day: 15);

      expect(
        schedule.nextAfter(LocalDate(2026, 6, 15)),
        LocalDate(2027, 6, 15),
      );
    });

    test('February 29 non-leap yilda February 28 olur', () {
      final schedule = BillingSchedule.yearly(month: 2, day: 29);

      expect(
        schedule.nextAfter(LocalDate(2024, 2, 29)),
        LocalDate(2025, 2, 28),
      );
    });

    test('February 29 sonraki leap yilda yeniden February 29 olur', () {
      final schedule = BillingSchedule.yearly(month: 2, day: 29);
      final due2025 = schedule.nextAfter(LocalDate(2024, 2, 29));
      final due2026 = schedule.nextAfter(due2025);
      final due2027 = schedule.nextAfter(due2026);
      final due2028 = schedule.nextAfter(due2027);

      expect(due2028, LocalDate(2028, 2, 29));
    });

    test('gecersiz month reddedilir', () {
      expect(
        () => BillingSchedule.yearly(month: 0, day: 1),
        throwsArgumentError,
      );
      expect(
        () => BillingSchedule.yearly(month: 13, day: 1),
        throwsArgumentError,
      );
    });

    test('February 30 reddedilir', () {
      expect(
        () => BillingSchedule.yearly(month: 2, day: 30),
        throwsArgumentError,
      );
    });

    test('April 31 reddedilir', () {
      expect(
        () => BillingSchedule.yearly(month: 4, day: 31),
        throwsArgumentError,
      );
    });
  });

  test('value equality ve hashCode alan degerlerine dayanir', () {
    final first = BillingSchedule.yearly(month: 2, day: 29);
    final second = BillingSchedule.yearly(month: 2, day: 29);

    expect(first, second);
    expect(first.hashCode, second.hashCode);
    expect(first, isNot(BillingSchedule.yearly(month: 2, day: 28)));
    expect(first, isNot(BillingSchedule.monthly(day: 29)));
  });
}
