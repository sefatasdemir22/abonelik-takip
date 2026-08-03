import '../../../core/domain/local_date.dart';

enum SystemCategory { entertainment, software, communication, other }

final class RecurringPayment {
  const RecurringPayment({
    required this.id,
    required this.name,
    required this.amountMinor,
    required this.currencyCode,
    required this.nextPaymentDate,
    required this.billingDay,
    required this.category,
    required this.createdAtUtc,
    this.paymentMethodNickname,
    this.active = true,
  });

  final String id;
  final String name;
  final int amountMinor;
  final String currencyCode;
  final LocalDate nextPaymentDate;
  final int billingDay;
  final String? paymentMethodNickname;
  final SystemCategory category;
  final bool active;
  final DateTime createdAtUtc;

  RecurringPayment copyWith({LocalDate? nextPaymentDate}) => RecurringPayment(
    id: id,
    name: name,
    amountMinor: amountMinor,
    currencyCode: currencyCode,
    nextPaymentDate: nextPaymentDate ?? this.nextPaymentDate,
    billingDay: billingDay,
    paymentMethodNickname: paymentMethodNickname,
    category: category,
    active: active,
    createdAtUtc: createdAtUtc,
  );
}
