import '../../../core/domain/local_date.dart';

enum PaymentOccurrenceStatus { awaitingConfirmation, paid, skipped }

final class PaymentOccurrence {
  const PaymentOccurrence({
    required this.id,
    required this.recurringPaymentId,
    required this.paymentName,
    required this.expectedDate,
    required this.expectedAmountMinor,
    required this.currencyCode,
    required this.status,
    this.actualAmountMinor,
    this.confirmedAtUtc,
  });

  final String id;
  final String recurringPaymentId;
  final String paymentName;
  final LocalDate expectedDate;
  final int expectedAmountMinor;
  final String currencyCode;
  final PaymentOccurrenceStatus status;
  final int? actualAmountMinor;
  final DateTime? confirmedAtUtc;
}

final class CurrencyMonthlySummary {
  const CurrencyMonthlySummary({
    required this.currencyCode,
    required this.paidMinor,
    required this.awaitingMinor,
    required this.remainingPlannedMinor,
  });

  final String currencyCode;
  final int paidMinor;
  final int awaitingMinor;
  final int remainingPlannedMinor;

  int get plannedMonthEndMinor =>
      paidMinor + awaitingMinor + remainingPlannedMinor;
}
