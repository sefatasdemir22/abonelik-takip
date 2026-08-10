import 'local_date.dart';

enum BillingCadence { monthly, yearly }

final class BillingSchedule {
  BillingSchedule.monthly({required int day})
    : cadence = BillingCadence.monthly,
      anchorDay = _validateMonthlyDay(day),
      anchorMonth = null;

  BillingSchedule.yearly({required int month, required int day})
    : cadence = BillingCadence.yearly,
      anchorDay = _validateYearlyDay(month, day),
      anchorMonth = _validateYearlyMonth(month);

  final BillingCadence cadence;
  final int anchorDay;
  final int? anchorMonth;

  LocalDate nextAfter(LocalDate currentDueDate) {
    switch (cadence) {
      case BillingCadence.monthly:
        return currentDueDate.addMonthsAnchored(1, anchorDay);
      case BillingCadence.yearly:
        final targetYear = currentDueDate.year + 1;
        final month = anchorMonth!;
        final lastDay = DateTime.utc(targetYear, month + 1, 0).day;
        return LocalDate(targetYear, month, anchorDay.clamp(1, lastDay));
    }
  }

  static int _validateMonthlyDay(int day) {
    if (day < 1 || day > 31) {
      throw ArgumentError.value(day, 'day', 'Must be between 1 and 31.');
    }
    return day;
  }

  static int _validateYearlyMonth(int month) {
    if (month < 1 || month > 12) {
      throw ArgumentError.value(month, 'month', 'Must be between 1 and 12.');
    }
    return month;
  }

  static int _validateYearlyDay(int month, int day) {
    _validateYearlyMonth(month);
    final lastDay = DateTime.utc(2000, month + 1, 0).day;
    if (day < 1 || day > lastDay) {
      throw ArgumentError.value(day, 'day', 'Invalid day for anchor month.');
    }
    return day;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BillingSchedule &&
          cadence == other.cadence &&
          anchorDay == other.anchorDay &&
          anchorMonth == other.anchorMonth;

  @override
  int get hashCode => Object.hash(cadence, anchorDay, anchorMonth);
}
