import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/domain/local_date.dart';
import '../../../core/persistence/app_database.dart';
import '../../recurring_payments/domain/recurring_payment_repository.dart';
import '../domain/payment_occurrence.dart';
import '../domain/payment_occurrence_repository.dart';

final class DriftPaymentOccurrenceRepository
    implements PaymentOccurrenceRepository {
  DriftPaymentOccurrenceRepository(
    this._database,
    this._recurringPayments, {
    Uuid? uuid,
  }) : _uuid = uuid ?? const Uuid();

  final AppDatabase _database;
  final RecurringPaymentRepository _recurringPayments;
  final Uuid _uuid;

  @override
  Future<int> materializeDueOccurrences(LocalDate today) async {
    var inserted = 0;
    await _database.transaction(() async {
      for (final payment in await _recurringPayments.getActive()) {
        var dueDate = payment.nextPaymentDate;
        while (dueDate.compareTo(today) <= 0) {
          final affected = await _database
              .into(_database.paymentOccurrences)
              .insert(
                PaymentOccurrencesCompanion.insert(
                  id: _uuid.v4(),
                  recurringPaymentId: payment.id,
                  paymentName: payment.name,
                  expectedDate: dueDate.toIso8601String(),
                  expectedAmountMinor: payment.amountMinor,
                  currencyCode: payment.currencyCode,
                  status: PaymentOccurrenceStatus.awaitingConfirmation.name,
                ),
                mode: InsertMode.insertOrIgnore,
              );
          if (affected > 0) inserted++;
          dueDate = payment.billingSchedule.nextAfter(dueDate);
        }
        if (dueDate != payment.nextPaymentDate) {
          await _recurringPayments.updateNextPaymentDate(
            payment.id,
            dueDate.toIso8601String(),
          );
        }
      }
    });
    return inserted;
  }

  @override
  Future<List<PaymentOccurrence>> getAwaitingConfirmation() async {
    final query = _database.select(_database.paymentOccurrences)
      ..where(
        (row) => row.status.equals(
          PaymentOccurrenceStatus.awaitingConfirmation.name,
        ),
      )
      ..orderBy([(row) => OrderingTerm.asc(row.expectedDate)]);
    return (await query.get()).map(_toDomain).toList(growable: false);
  }

  @override
  Future<void> markPaid(String id, DateTime confirmedAtUtc) => _setStatus(
    id,
    PaymentOccurrenceStatus.paid,
    confirmedAtUtc,
    copyExpectedAmount: true,
  );

  @override
  Future<void> markSkipped(String id, DateTime confirmedAtUtc) => _setStatus(
    id,
    PaymentOccurrenceStatus.skipped,
    confirmedAtUtc,
    copyExpectedAmount: false,
  );

  Future<void> _setStatus(
    String id,
    PaymentOccurrenceStatus status,
    DateTime confirmedAtUtc, {
    required bool copyExpectedAmount,
  }) async {
    final row = await (_database.select(
      _database.paymentOccurrences,
    )..where((item) => item.id.equals(id))).getSingle();
    await (_database.update(
      _database.paymentOccurrences,
    )..where((item) => item.id.equals(id))).write(
      PaymentOccurrencesCompanion(
        status: Value(status.name),
        actualAmountMinor: Value(
          copyExpectedAmount ? row.expectedAmountMinor : null,
        ),
        confirmedAtUtc: Value(confirmedAtUtc.toUtc()),
      ),
    );
  }

  @override
  Future<List<CurrencyMonthlySummary>> getMonthlySummary(
    LocalDate today,
  ) async {
    final first = LocalDate(today.year, today.month, 1);
    final firstNextMonth = today.month == 12
        ? LocalDate(today.year + 1, 1, 1)
        : LocalDate(today.year, today.month + 1, 1);
    final last = firstNextMonth.addDays(-1);
    final occurrenceQuery = _database.select(_database.paymentOccurrences)
      ..where(
        (row) => row.expectedDate.isBetweenValues(
          first.toIso8601String(),
          last.toIso8601String(),
        ),
      );
    final occurrences = await occurrenceQuery.get();
    final active = await _recurringPayments.getActive();
    final totals = <String, _MutableSummary>{};

    for (final row in occurrences) {
      final status = PaymentOccurrenceStatus.values.byName(row.status);
      if (status == PaymentOccurrenceStatus.paid) {
        final target = totals.putIfAbsent(
          row.currencyCode,
          _MutableSummary.new,
        );
        target.paid += row.actualAmountMinor ?? row.expectedAmountMinor;
      } else if (status == PaymentOccurrenceStatus.awaitingConfirmation) {
        final target = totals.putIfAbsent(
          row.currencyCode,
          _MutableSummary.new,
        );
        target.awaiting += row.expectedAmountMinor;
      }
    }
    for (final payment in active) {
      final date = payment.nextPaymentDate;
      if (date.compareTo(today) > 0 && date.compareTo(last) <= 0) {
        totals
                .putIfAbsent(payment.currencyCode, _MutableSummary.new)
                .remaining +=
            payment.amountMinor;
      }
    }
    final result = totals.entries
        .map(
          (entry) => CurrencyMonthlySummary(
            currencyCode: entry.key,
            paidMinor: entry.value.paid,
            awaitingMinor: entry.value.awaiting,
            remainingPlannedMinor: entry.value.remaining,
          ),
        )
        .toList(growable: false);
    result.sort((a, b) => a.currencyCode.compareTo(b.currencyCode));
    return result;
  }

  PaymentOccurrence _toDomain(PaymentOccurrenceRow row) => PaymentOccurrence(
    id: row.id,
    recurringPaymentId: row.recurringPaymentId,
    paymentName: row.paymentName,
    expectedDate: LocalDate.parse(row.expectedDate),
    expectedAmountMinor: row.expectedAmountMinor,
    currencyCode: row.currencyCode,
    status: PaymentOccurrenceStatus.values.byName(row.status),
    actualAmountMinor: row.actualAmountMinor,
    confirmedAtUtc: row.confirmedAtUtc,
  );
}

final class _MutableSummary {
  int paid = 0;
  int awaiting = 0;
  int remaining = 0;
}
