import 'package:abonelik_takip/core/domain/local_date.dart';
import 'package:abonelik_takip/core/persistence/app_database.dart';
import 'package:abonelik_takip/features/payment_occurrences/data/drift_payment_occurrence_repository.dart';
import 'package:abonelik_takip/features/recurring_payments/data/drift_recurring_payment_repository.dart';
import 'package:abonelik_takip/features/recurring_payments/domain/recurring_payment.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late DriftRecurringPaymentRepository recurring;
  late DriftPaymentOccurrenceRepository occurrences;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    recurring = DriftRecurringPaymentRepository(database);
    occurrences = DriftPaymentOccurrenceRepository(database, recurring);
  });

  tearDown(() => database.close());

  test('repository eklenen aktif kaydı tarih sırasıyla döndürür', () async {
    await recurring.add(_payment(id: 'one', date: LocalDate(2026, 8, 12)));
    final rows = await recurring.getActive();
    expect(rows.single.id, 'one');
    expect(rows.single.amountMinor, 12990);
  });

  test('aynı vade için yalnız tek occurrence üretir', () async {
    await recurring.add(_payment(id: 'one', date: LocalDate(2026, 8, 3)));

    expect(
      await occurrences.materializeDueOccurrences(LocalDate(2026, 8, 3)),
      1,
    );
    expect(
      await occurrences.materializeDueOccurrences(LocalDate(2026, 8, 3)),
      0,
    );
    expect((await occurrences.getAwaitingConfirmation()).length, 1);
  });

  test('31 günlük aylık ankraj Şubat sonrasında 31 güne geri döner', () async {
    await recurring.add(
      _payment(id: 'month-end', date: LocalDate(2024, 1, 31)),
    );
    await occurrences.materializeDueOccurrences(LocalDate(2024, 2, 29));

    final payment = (await recurring.getActive()).single;
    expect(payment.nextPaymentDate, LocalDate(2024, 3, 31));
    expect((await occurrences.getAwaitingConfirmation()).length, 2);
  });

  test(
    'paid toplama girer, skipped girmez ve para birimleri ayrıdır',
    () async {
      await recurring.add(_payment(id: 'try', date: LocalDate(2026, 8, 1)));
      await recurring.add(
        _payment(id: 'usd', date: LocalDate(2026, 8, 2), currency: 'USD'),
      );
      await occurrences.materializeDueOccurrences(LocalDate(2026, 8, 3));
      final awaiting = await occurrences.getAwaitingConfirmation();
      await occurrences.markPaid(
        awaiting.singleWhere((item) => item.currencyCode == 'TRY').id,
        DateTime.utc(2026, 8, 3),
      );
      await occurrences.markSkipped(
        awaiting.singleWhere((item) => item.currencyCode == 'USD').id,
        DateTime.utc(2026, 8, 3),
      );

      final summaries = await occurrences.getMonthlySummary(
        LocalDate(2026, 8, 3),
      );
      expect(summaries.map((item) => item.currencyCode), ['TRY']);
      expect(summaries.single.paidMinor, 12990);
      expect(summaries.single.awaitingMinor, 0);
    },
  );
}

RecurringPayment _payment({
  required String id,
  required LocalDate date,
  String currency = 'TRY',
}) => RecurringPayment(
  id: id,
  name: 'Test ödeme',
  amountMinor: 12990,
  currencyCode: currency,
  nextPaymentDate: date,
  billingDay: date.day,
  category: SystemCategory.software,
  createdAtUtc: DateTime.utc(2026, 8, 1),
);
