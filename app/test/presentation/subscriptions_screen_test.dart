import 'package:abonelik_takip/core/domain/app_clock.dart';
import 'package:abonelik_takip/core/domain/billing_schedule.dart';
import 'package:abonelik_takip/core/domain/local_date.dart';
import 'package:abonelik_takip/features/notifications/domain/notification_scheduler.dart';
import 'package:abonelik_takip/features/recurring_payments/application/add_recurring_payment.dart';
import 'package:abonelik_takip/features/recurring_payments/application/get_active_recurring_payments.dart';
import 'package:abonelik_takip/features/recurring_payments/domain/recurring_payment.dart';
import 'package:abonelik_takip/features/recurring_payments/domain/recurring_payment_repository.dart';
import 'package:abonelik_takip/features/subscriptions/presentation/subscriptions_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('empty result kişisel empty state gösterir', (tester) async {
    await tester.pumpWidget(_appWith(const []));
    await tester.pumpAndSettle();

    expect(find.text('Kişisel aboneliklerin'), findsOneWidget);
  });

  testWidgets('gerçek abonelik bilgilerini cadence ile gösterir', (
    tester,
  ) async {
    await tester.pumpWidget(
      _appWith([
        _payment(
          id: 'netflix',
          name: 'Netflix',
          amountMinor: 22999,
          currencyCode: 'TRY',
          date: LocalDate(2026, 8, 15),
          schedule: BillingSchedule.monthly(day: 15),
        ),
        _payment(
          id: 'cloud',
          name: 'Cloud',
          amountMinor: 999,
          currencyCode: 'USD',
          date: LocalDate(2026, 12, 2),
          schedule: BillingSchedule.yearly(month: 12, day: 2),
        ),
      ]),
    );
    await tester.pumpAndSettle();

    expect(find.text('Netflix'), findsOneWidget);
    expect(find.text('229,99 TRY'), findsOneWidget);
    expect(find.text('15 Ağu 2026'), findsOneWidget);
    expect(find.text('Aylık'), findsOneWidget);
    expect(find.text('Cloud'), findsOneWidget);
    expect(find.text('9,99 USD'), findsOneWidget);
    expect(find.text('2 Ara 2026'), findsOneWidget);
    expect(find.text('Yıllık'), findsOneWidget);
    expect(find.textContaining('Toplam'), findsNothing);
  });

  testWidgets('paylaşılan sekmede kişisel ekleme FAB gizlenir', (tester) async {
    await tester.pumpWidget(_appWith(const []));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Paylaşılan'));
    await tester.pump();

    expect(find.text('Kişisel aboneliklerin'), findsNothing);
    expect(find.text('Paylaşılan abonelikler'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('Abonelik ekle'), findsNothing);
  });

  testWidgets('repository failure keeps dialog open and allows retry', (
    tester,
  ) async {
    final repository = _FakeRepository([])..remainingAddFailures = 1;
    await tester.pumpWidget(_appWithDependencies(repository));
    await tester.pumpAndSettle();
    await _openAndFillDialog(tester);

    await tester.tap(find.byKey(const Key('save-payment')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('save-payment-error')), findsOneWidget);
    final retryButton = tester.widget<FilledButton>(
      find.byKey(const Key('save-payment')),
    );
    expect(retryButton.onPressed, isNotNull);

    await tester.tap(find.byKey(const Key('save-payment')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('save-payment')), findsNothing);
    expect(repository.addCalls, 2);
    expect(repository.payments, hasLength(1));
  });

  testWidgets('notification failure closes dialog and shows warning', (
    tester,
  ) async {
    final repository = _FakeRepository([]);
    final scheduler = _FakeNotificationScheduler()..failScheduling = true;
    var refreshCalls = 0;
    await tester.pumpWidget(
      _appWithDependencies(
        repository,
        scheduler: scheduler,
        onPaymentAdded: () async => refreshCalls++,
      ),
    );
    await tester.pumpAndSettle();
    await _openAndFillDialog(tester);

    await tester.tap(find.byKey(const Key('save-payment')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('save-payment')), findsNothing);
    expect(
      find.text('Abonelik kaydedildi ancak bildirim ayarlanamadı.'),
      findsOneWidget,
    );
    expect(repository.addCalls, 1);
    expect(repository.payments, hasLength(1));
    expect(refreshCalls, 1);
  });

  testWidgets('personal card opens detail and back returns to list', (
    tester,
  ) async {
    await tester.pumpWidget(
      _appWith([
        _payment(
          id: 'netflix',
          name: 'Netflix',
          amountMinor: 22999,
          currencyCode: 'TRY',
          date: LocalDate(2026, 8, 15),
          schedule: BillingSchedule.monthly(day: 15),
          paymentMethodNickname: 'Bonus kart',
        ),
      ]),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Netflix'));
    await tester.pumpAndSettle();

    expect(find.text('Abonelik detayı'), findsOneWidget);
    expect(find.text('Netflix'), findsOneWidget);
    expect(find.text('229,99 TRY'), findsOneWidget);
    expect(find.text('15 Ağu 2026'), findsOneWidget);
    expect(find.text('Aylık'), findsOneWidget);
    expect(find.text('Eğlence'), findsOneWidget);
    expect(find.text('Ödeme yöntemi'), findsOneWidget);
    expect(find.text('Bonus kart'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.text('Aboneliklerim'), findsOneWidget);
    expect(find.text('Netflix'), findsOneWidget);
  });

  testWidgets('USD detail preserves currency and hides blank payment method', (
    tester,
  ) async {
    await tester.pumpWidget(
      _appWith([
        _payment(
          id: 'cloud',
          name: 'Cloud',
          amountMinor: 999,
          currencyCode: 'USD',
          date: LocalDate(2026, 12, 2),
          schedule: BillingSchedule.yearly(month: 12, day: 2),
          category: SystemCategory.software,
          paymentMethodNickname: '   ',
        ),
      ]),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cloud'));
    await tester.pumpAndSettle();

    expect(find.text('9,99 USD'), findsOneWidget);
    expect(find.text('Yıllık'), findsOneWidget);
    expect(find.text('Yazılım'), findsOneWidget);
    expect(find.text('Ödeme yöntemi'), findsNothing);
    expect(find.textContaining('TRY'), findsNothing);
    expect(find.textContaining('Toplam'), findsNothing);
  });
}

Widget _appWith(List<RecurringPayment> payments) {
  final repository = _FakeRepository(payments);
  return _appWithDependencies(repository);
}

Widget _appWithDependencies(
  _FakeRepository repository, {
  _FakeNotificationScheduler? scheduler,
  Future<void> Function()? onPaymentAdded,
}) {
  return MaterialApp(
    home: SubscriptionsScreen(
      addRecurringPayment: AddRecurringPayment(
        repository,
        scheduler ?? _FakeNotificationScheduler(),
        FakeAppClock(DateTime.utc(2026, 8, 1)),
      ),
      getActiveRecurringPayments: GetActiveRecurringPayments(repository),
      onPaymentAdded: onPaymentAdded ?? () async {},
    ),
  );
}

Future<void> _openAndFillDialog(WidgetTester tester) async {
  await tester.tap(find.text('Abonelik ekle'));
  await tester.pumpAndSettle();
  await tester.enterText(find.byKey(const Key('payment-name')), 'Spotify');
  await tester.enterText(find.byKey(const Key('payment-amount')), '59,99');
  await tester.ensureVisible(find.byIcon(Icons.calendar_today));
  await tester.tap(find.byIcon(Icons.calendar_today));
  await tester.pumpAndSettle();
  await tester.tap(find.text('15').last);
  await tester.tap(
    find
        .descendant(
          of: find.byType(DatePickerDialog),
          matching: find.byType(TextButton),
        )
        .last,
  );
  await tester.pumpAndSettle();
}

RecurringPayment _payment({
  required String id,
  required String name,
  required int amountMinor,
  required String currencyCode,
  required LocalDate date,
  required BillingSchedule schedule,
  SystemCategory category = SystemCategory.entertainment,
  String? paymentMethodNickname,
}) => RecurringPayment(
  id: id,
  name: name,
  amountMinor: amountMinor,
  currencyCode: currencyCode,
  nextPaymentDate: date,
  billingSchedule: schedule,
  paymentMethodNickname: paymentMethodNickname,
  category: category,
  createdAtUtc: DateTime.utc(2026, 8, 1),
);

final class _FakeRepository implements RecurringPaymentRepository {
  _FakeRepository(List<RecurringPayment> payments)
    : payments = List.of(payments);

  final List<RecurringPayment> payments;
  int remainingAddFailures = 0;
  int addCalls = 0;

  @override
  Future<List<RecurringPayment>> getActive() async => payments;

  @override
  Future<void> add(RecurringPayment payment) async {
    addCalls++;
    if (remainingAddFailures > 0) {
      remainingAddFailures--;
      throw StateError('database unavailable');
    }
    payments.add(payment);
  }

  @override
  Future<void> updateNextPaymentDate(String id, String nextDateIso) async {}
}

final class _FakeNotificationScheduler implements NotificationScheduler {
  bool failScheduling = false;

  @override
  Future<void> cancelForOccurrence(String recurringPaymentId) async {}

  @override
  Future<void> initialize() async {}

  @override
  Future<void> requestPermission() async {}

  @override
  Future<void> scheduleFor(RecurringPayment payment) async {
    if (failScheduling) throw StateError('notifications unavailable');
  }
}
