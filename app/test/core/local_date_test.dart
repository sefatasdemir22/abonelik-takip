import 'package:abonelik_takip/core/domain/app_clock.dart';
import 'package:abonelik_takip/core/domain/local_date.dart';
import 'package:abonelik_takip/core/domain/money.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ay eklerken ay sonunu güvenli biçimde sınırlar', () {
    expect(LocalDate(2024, 1, 31).addMonths(1), LocalDate(2024, 2, 29));
    expect(LocalDate(2025, 1, 31).addMonths(1), LocalDate(2025, 2, 28));
  });

  test('aylık ankraj Şubat sonrasındaki asıl güne geri döner', () {
    final february = LocalDate(2024, 1, 31).addMonthsAnchored(1, 31);
    expect(february, LocalDate(2024, 2, 29));
    expect(february.addMonthsAnchored(1, 31), LocalDate(2024, 3, 31));
  });

  test('fake clock yerel iş tarihini deterministik verir', () {
    final clock = FakeAppClock(DateTime(2026, 8, 3, 23, 30));
    expect(clock.todayLocal(), LocalDate(2026, 8, 3));
    clock.advance(const Duration(hours: 2));
    expect(clock.todayLocal(), LocalDate(2026, 8, 4));
  });

  test('para tutarı double kullanmadan minor unit olarak ayrıştırılır', () {
    expect(parseMinorUnits('129,90'), 12990);
    expect(parseMinorUnits('10.5'), 1050);
    expect(() => parseMinorUnits('1.999'), throwsFormatException);
  });
}
