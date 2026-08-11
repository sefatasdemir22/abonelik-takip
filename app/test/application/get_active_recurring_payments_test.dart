import 'package:abonelik_takip/features/recurring_payments/application/get_active_recurring_payments.dart';
import 'package:abonelik_takip/features/recurring_payments/domain/recurring_payment.dart';
import 'package:abonelik_takip/features/recurring_payments/domain/recurring_payment_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('repository sonucunu değiştirmeden döndürür', () async {
    final expected = <RecurringPayment>[];
    final repository = _FakeRepository(expected);

    final result = await GetActiveRecurringPayments(repository)();

    expect(result, same(expected));
    expect(repository.getActiveCalls, 1);
  });
}

final class _FakeRepository implements RecurringPaymentRepository {
  _FakeRepository(this.result);

  final List<RecurringPayment> result;
  int getActiveCalls = 0;

  @override
  Future<List<RecurringPayment>> getActive() async {
    getActiveCalls++;
    return result;
  }

  @override
  Future<void> add(RecurringPayment payment) async {}

  @override
  Future<void> updateNextPaymentDate(String id, String nextDateIso) async {}
}
