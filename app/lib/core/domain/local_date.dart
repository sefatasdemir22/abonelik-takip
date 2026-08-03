final class LocalDate implements Comparable<LocalDate> {
  LocalDate(this.year, this.month, this.day) {
    final normalized = DateTime.utc(year, month, day);
    if (normalized.year != year ||
        normalized.month != month ||
        normalized.day != day) {
      throw ArgumentError.value(toIso8601String(), 'date', 'Geçersiz tarih');
    }
  }

  factory LocalDate.fromDateTime(DateTime value) =>
      LocalDate(value.year, value.month, value.day);

  factory LocalDate.parse(String value) {
    final parts = value.split('-');
    if (parts.length != 3) throw FormatException('Geçersiz LocalDate: $value');
    return LocalDate(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  final int year;
  final int month;
  final int day;

  DateTime atLocalTime({int hour = 0, int minute = 0}) =>
      DateTime(year, month, day, hour, minute);

  LocalDate addMonths(int count) {
    final zeroBased = year * 12 + month - 1 + count;
    final targetYear = zeroBased ~/ 12;
    final targetMonth = zeroBased % 12 + 1;
    final lastDay = DateTime.utc(targetYear, targetMonth + 1, 0).day;
    return LocalDate(targetYear, targetMonth, day.clamp(1, lastDay));
  }

  LocalDate addMonthsAnchored(int count, int anchorDay) {
    if (anchorDay < 1 || anchorDay > 31) {
      throw ArgumentError.value(anchorDay, 'anchorDay');
    }
    final zeroBased = year * 12 + month - 1 + count;
    final targetYear = zeroBased ~/ 12;
    final targetMonth = zeroBased % 12 + 1;
    final lastDay = DateTime.utc(targetYear, targetMonth + 1, 0).day;
    return LocalDate(targetYear, targetMonth, anchorDay.clamp(1, lastDay));
  }

  LocalDate addDays(int count) {
    final value = DateTime.utc(year, month, day).add(Duration(days: count));
    return LocalDate(value.year, value.month, value.day);
  }

  bool isBefore(LocalDate other) => compareTo(other) < 0;
  bool isAfter(LocalDate other) => compareTo(other) > 0;

  @override
  int compareTo(LocalDate other) => (year * 10000 + month * 100 + day)
      .compareTo(other.year * 10000 + other.month * 100 + other.day);

  String toIso8601String() =>
      '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';

  @override
  String toString() => toIso8601String();

  @override
  bool operator ==(Object other) =>
      other is LocalDate &&
      year == other.year &&
      month == other.month &&
      day == other.day;

  @override
  int get hashCode => Object.hash(year, month, day);
}
