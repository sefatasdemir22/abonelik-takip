import 'package:drift/drift.dart';

import '../../../core/domain/local_date.dart';
import '../../../core/persistence/app_database.dart';
import '../domain/recurring_payment.dart';
import '../domain/recurring_payment_repository.dart';

final class DriftRecurringPaymentRepository
    implements RecurringPaymentRepository {
  DriftRecurringPaymentRepository(this._database);

  final AppDatabase _database;

  @override
  Future<void> add(RecurringPayment payment) => _database
      .into(_database.recurringPayments)
      .insert(
        RecurringPaymentsCompanion.insert(
          id: payment.id,
          name: payment.name,
          amountMinor: payment.amountMinor,
          currencyCode: payment.currencyCode,
          nextPaymentDate: payment.nextPaymentDate.toIso8601String(),
          billingDay: payment.billingDay,
          paymentMethodNickname: Value(payment.paymentMethodNickname),
          category: payment.category.name,
          active: Value(payment.active),
          createdAtUtc: payment.createdAtUtc,
        ),
      );

  @override
  Future<List<RecurringPayment>> getActive() async {
    final query = _database.select(_database.recurringPayments)
      ..where((row) => row.active.equals(true))
      ..orderBy([(row) => OrderingTerm.asc(row.nextPaymentDate)]);
    return (await query.get()).map(_toDomain).toList(growable: false);
  }

  @override
  Future<void> updateNextPaymentDate(String id, String nextDateIso) async {
    await (_database.update(_database.recurringPayments)
          ..where((row) => row.id.equals(id)))
        .write(RecurringPaymentsCompanion(nextPaymentDate: Value(nextDateIso)));
  }

  RecurringPayment _toDomain(RecurringPaymentRow row) => RecurringPayment(
    id: row.id,
    name: row.name,
    amountMinor: row.amountMinor,
    currencyCode: row.currencyCode,
    nextPaymentDate: LocalDate.parse(row.nextPaymentDate),
    billingDay: row.billingDay,
    paymentMethodNickname: row.paymentMethodNickname,
    category: SystemCategory.values.byName(row.category),
    active: row.active,
    createdAtUtc: row.createdAtUtc,
  );
}
