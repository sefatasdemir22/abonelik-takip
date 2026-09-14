import 'package:abonelik_takip/core/domain/app_clock.dart';
import 'package:abonelik_takip/core/domain/billing_schedule.dart';
import 'package:abonelik_takip/core/domain/local_date.dart';
import 'package:abonelik_takip/features/notifications/domain/notification_scheduler.dart';
import 'package:abonelik_takip/features/recurring_payments/application/add_recurring_payment.dart';
import 'package:abonelik_takip/features/recurring_payments/application/get_active_recurring_payments.dart';
import 'package:abonelik_takip/features/recurring_payments/application/update_recurring_payment.dart';
import 'package:abonelik_takip/features/recurring_payments/domain/recurring_payment.dart';
import 'package:abonelik_takip/features/recurring_payments/domain/recurring_payment_repository.dart';
import 'package:abonelik_takip/features/subscriptions/presentation/subscriptions_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('inactive tab activation reloads the latest payment snapshot', (
    tester,
  ) async {
    final repository = _FakeRepository([
      _payment(
        id: 'spotify',
        name: 'Spotify',
        amountMinor: 5999,
        currencyCode: 'TRY',
        date: LocalDate(2026, 8, 15),
        schedule: BillingSchedule.monthly(day: 15),
      ),
    ]);
    await tester.pumpWidget(_appWithDependencies(repository, isActive: false));
    await tester.pumpAndSettle();
    expect(find.text('15 Ağu 2026'), findsOneWidget);
    expect(repository.getActiveCalls, 1);

    repository.payments[0] = _payment(
      id: 'spotify',
      name: 'Spotify',
      amountMinor: 5999,
      currencyCode: 'TRY',
      date: LocalDate(2026, 9, 15),
      schedule: BillingSchedule.monthly(day: 15),
    );
    await tester.pumpWidget(_appWithDependencies(repository, isActive: true));
    await tester.pumpAndSettle();
    expect(find.text('15 Eyl 2026'), findsOneWidget);
    expect(find.text('15 Ağu 2026'), findsNothing);
    expect(repository.getActiveCalls, 2);

    await tester.pumpWidget(_appWithDependencies(repository, isActive: true));
    await tester.pumpAndSettle();
    expect(repository.getActiveCalls, 2);
  });

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
        onPaymentsChanged: () async => refreshCalls++,
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

  testWidgets('add currency selector defaults TRY and only supports V1 list', (
    tester,
  ) async {
    final repository = _FakeRepository([]);
    await tester.pumpWidget(_appWithDependencies(repository));
    await tester.pumpAndSettle();
    await _openAndFillDialog(tester);

    expect(find.text('TRY — Türk Lirası'), findsOneWidget);
    await tester.tap(find.byKey(const Key('payment-currency')));
    await tester.pumpAndSettle();
    expect(find.text('USD — ABD Doları'), findsOneWidget);
    expect(find.text('EUR — Euro'), findsOneWidget);
    expect(find.text('GBP — İngiliz Sterlini'), findsOneWidget);
    expect(find.textContaining('CHF'), findsNothing);
    await tester.tap(find.text('USD — ABD Doları').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save-payment')));
    await tester.pumpAndSettle();

    expect(repository.payments.single.currencyCode, 'USD');
  });

  testWidgets('successful edit updates detail list and refresh callback', (
    tester,
  ) async {
    final repository = _FakeRepository([
      _payment(
        id: 'spotify',
        name: 'Spotify',
        amountMinor: 5999,
        currencyCode: 'TRY',
        date: LocalDate(2026, 8, 15),
        schedule: BillingSchedule.monthly(day: 15),
        paymentMethodNickname: 'Bonus',
      ),
    ]);
    final scheduler = _FakeNotificationScheduler();
    var refreshCalls = 0;
    await tester.pumpWidget(
      _appWithDependencies(
        repository,
        scheduler: scheduler,
        onPaymentsChanged: () async => refreshCalls++,
      ),
    );
    await tester.pumpAndSettle();
    await _openEdit(tester, 'Spotify');

    expect(find.text('Spotify'), findsNWidgets(2));
    expect(find.text('59,99'), findsOneWidget);
    expect(find.text('TRY — Türk Lirası'), findsOneWidget);
    expect(find.text('Bonus'), findsNWidgets(2));
    expect(find.text('15.08.2026'), findsOneWidget);
    final cadenceSelector = tester.widget<SegmentedButton<BillingCadence>>(
      find.byType(SegmentedButton<BillingCadence>),
    );
    expect(cadenceSelector.selected, {BillingCadence.monthly});
    final categorySelector = tester
        .widget<DropdownButtonFormField<SystemCategory>>(
          find.byType(DropdownButtonFormField<SystemCategory>),
        );
    expect(categorySelector.initialValue, SystemCategory.entertainment);
    await tester.enterText(
      find.byKey(const Key('edit-payment-name')),
      'Spotify Premium',
    );
    await tester.enterText(
      find.byKey(const Key('edit-payment-amount')),
      '79,99',
    );
    await tester.tap(find.byKey(const Key('payment-currency')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('USD — ABD Doları').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save-edit-payment')));
    await tester.pumpAndSettle();

    expect(find.text('Spotify Premium'), findsOneWidget);
    expect(find.text('79,99 USD'), findsOneWidget);
    expect(repository.updateCalls, 1);
    expect(repository.addCalls, 0);
    expect(scheduler.permissionRequests, 0);
    expect(scheduler.cancelledIds, ['spotify']);
    expect(scheduler.scheduled, hasLength(1));
    expect(refreshCalls, 1);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Spotify Premium'), findsOneWidget);
    expect(find.text('79,99 USD'), findsOneWidget);
  });

  testWidgets('edit repository failure stays open and retry succeeds', (
    tester,
  ) async {
    final repository = _FakeRepository([
      _payment(
        id: 'spotify',
        name: 'Spotify',
        amountMinor: 5999,
        currencyCode: 'TRY',
        date: LocalDate(2026, 8, 15),
        schedule: BillingSchedule.monthly(day: 15),
      ),
    ])..remainingUpdateFailures = 1;
    await tester.pumpWidget(_appWithDependencies(repository));
    await tester.pumpAndSettle();
    await _openEdit(tester, 'Spotify');

    await tester.tap(find.byKey(const Key('save-edit-payment')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('edit-payment-error')), findsOneWidget);
    final retry = tester.widget<FilledButton>(
      find.byKey(const Key('save-edit-payment')),
    );
    expect(retry.onPressed, isNotNull);

    await tester.tap(find.byKey(const Key('save-edit-payment')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('save-edit-payment')), findsNothing);
    expect(repository.updateCalls, 2);
  });

  testWidgets('edit notification failure updates UI and shows warning', (
    tester,
  ) async {
    final repository = _FakeRepository([
      _payment(
        id: 'spotify',
        name: 'Spotify',
        amountMinor: 5999,
        currencyCode: 'TRY',
        date: LocalDate(2026, 8, 15),
        schedule: BillingSchedule.monthly(day: 15),
      ),
    ]);
    final scheduler = _FakeNotificationScheduler()..failScheduling = true;
    var refreshCalls = 0;
    await tester.pumpWidget(
      _appWithDependencies(
        repository,
        scheduler: scheduler,
        onPaymentsChanged: () async => refreshCalls++,
      ),
    );
    await tester.pumpAndSettle();
    await _openEdit(tester, 'Spotify');
    await tester.enterText(
      find.byKey(const Key('edit-payment-name')),
      'Spotify Updated',
    );

    await tester.tap(find.byKey(const Key('save-edit-payment')));
    await tester.pumpAndSettle();

    expect(find.text('Spotify Updated'), findsOneWidget);
    expect(
      find.text('Abonelik güncellendi ancak bildirim yeniden ayarlanamadı.'),
      findsOneWidget,
    );
    expect(repository.updateCalls, 1);
    expect(repository.addCalls, 0);
    expect(refreshCalls, 1);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Spotify Updated'), findsOneWidget);
    expect(refreshCalls, 1);
  });

  testWidgets('legacy currency opens safely and can change to supported', (
    tester,
  ) async {
    final repository = _FakeRepository([
      _payment(
        id: 'legacy',
        name: 'Legacy',
        amountMinor: 1000,
        currencyCode: 'CHF',
        date: LocalDate(2026, 8, 15),
        schedule: BillingSchedule.monthly(day: 15),
      ),
    ]);
    await tester.pumpWidget(_appWithDependencies(repository));
    await tester.pumpAndSettle();
    await _openEdit(tester, 'Legacy');

    expect(find.text('CHF — Mevcut para birimi'), findsOneWidget);
    await tester.tap(find.byKey(const Key('payment-currency')));
    await tester.pumpAndSettle();
    expect(find.textContaining('ABC'), findsNothing);
    await tester.tap(find.text('EUR — Euro').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save-edit-payment')));
    await tester.pumpAndSettle();

    expect(find.text('10,00 EUR'), findsOneWidget);
  });

  testWidgets('cancel edit does not mutate payment', (tester) async {
    final repository = _FakeRepository([
      _payment(
        id: 'spotify',
        name: 'Spotify',
        amountMinor: 5999,
        currencyCode: 'TRY',
        date: LocalDate(2026, 8, 15),
        schedule: BillingSchedule.monthly(day: 15),
      ),
    ]);
    await tester.pumpWidget(_appWithDependencies(repository));
    await tester.pumpAndSettle();
    await _openEdit(tester, 'Spotify');
    await tester.enterText(
      find.byKey(const Key('edit-payment-name')),
      'Changed',
    );

    await tester.tap(find.text('Vazgeç'));
    await tester.pumpAndSettle();

    expect(find.text('Spotify'), findsOneWidget);
    expect(find.text('Changed'), findsNothing);
    expect(repository.updateCalls, 0);
  });

  testWidgets('moving edited due date forward keeps list ascending', (
    tester,
  ) async {
    await _expectEditReorders(
      tester,
      editName: 'Early',
      newDay: 25,
      expectedFirst: 'Later',
    );
  });

  testWidgets('moving edited due date backward keeps list ascending', (
    tester,
  ) async {
    await _expectEditReorders(
      tester,
      editName: 'Later',
      newDay: 10,
      expectedFirst: 'Later',
    );
  });
}

Future<void> _expectEditReorders(
  WidgetTester tester, {
  required String editName,
  required int newDay,
  required String expectedFirst,
}) async {
  final repository = _FakeRepository([
    _payment(
      id: 'early',
      name: 'Early',
      amountMinor: 1000,
      currencyCode: 'TRY',
      date: LocalDate(2026, 8, 15),
      schedule: BillingSchedule.monthly(day: 15),
    ),
    _payment(
      id: 'later',
      name: 'Later',
      amountMinor: 2000,
      currencyCode: 'TRY',
      date: LocalDate(2026, 8, 20),
      schedule: BillingSchedule.monthly(day: 20),
    ),
  ]);
  var refreshCalls = 0;
  await tester.pumpWidget(
    _appWithDependencies(
      repository,
      onPaymentsChanged: () async => refreshCalls++,
    ),
  );
  await tester.pumpAndSettle();
  await _openEdit(tester, editName);
  await tester.ensureVisible(find.byIcon(Icons.calendar_today));
  await tester.pumpAndSettle();
  await tester.tap(find.byIcon(Icons.calendar_today));
  await tester.pumpAndSettle();
  await tester.tap(find.text('$newDay').last);
  await tester.tap(
    find
        .descendant(
          of: find.byType(DatePickerDialog),
          matching: find.byType(TextButton),
        )
        .last,
  );
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('save-edit-payment')));
  await tester.pumpAndSettle();
  await tester.pageBack();
  await tester.pumpAndSettle();

  final other = expectedFirst == 'Early' ? 'Later' : 'Early';
  expect(
    tester.getTopLeft(find.text(expectedFirst)).dy,
    lessThan(tester.getTopLeft(find.text(other)).dy),
  );
  expect(refreshCalls, 1);
}

Widget _appWith(List<RecurringPayment> payments) {
  final repository = _FakeRepository(payments);
  return _appWithDependencies(repository);
}

Widget _appWithDependencies(
  _FakeRepository repository, {
  bool isActive = true,
  _FakeNotificationScheduler? scheduler,
  Future<void> Function()? onPaymentsChanged,
}) {
  final notificationScheduler = scheduler ?? _FakeNotificationScheduler();
  return MaterialApp(
    home: SubscriptionsScreen(
      isActive: isActive,
      addRecurringPayment: AddRecurringPayment(
        repository,
        notificationScheduler,
        FakeAppClock(DateTime.utc(2026, 8, 1)),
      ),
      getActiveRecurringPayments: GetActiveRecurringPayments(repository),
      updateRecurringPayment: UpdateRecurringPayment(
        repository,
        notificationScheduler,
      ),
      onPaymentsChanged: onPaymentsChanged ?? () async {},
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

Future<void> _openEdit(WidgetTester tester, String paymentName) async {
  await tester.tap(find.text(paymentName));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Düzenle'));
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
  int updateCalls = 0;
  int getActiveCalls = 0;
  int remainingUpdateFailures = 0;

  @override
  Future<List<RecurringPayment>> getActive() async {
    getActiveCalls++;
    return List.of(payments, growable: false);
  }

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
  Future<void> update(RecurringPayment payment) async {
    updateCalls++;
    if (remainingUpdateFailures > 0) {
      remainingUpdateFailures--;
      throw StateError('database unavailable');
    }
    final index = payments.indexWhere((current) => current.id == payment.id);
    if (index >= 0) payments[index] = payment;
  }

  @override
  Future<void> updateNextPaymentDate(String id, String nextDateIso) async {}
}

final class _FakeNotificationScheduler implements NotificationScheduler {
  bool failScheduling = false;
  bool failCancellation = false;
  int permissionRequests = 0;
  final List<String> cancelledIds = [];
  final List<RecurringPayment> scheduled = [];

  @override
  Future<void> cancelForOccurrence(String recurringPaymentId) async {
    cancelledIds.add(recurringPaymentId);
    if (failCancellation) throw StateError('cancel unavailable');
  }

  @override
  Future<void> initialize() async {}

  @override
  Future<void> requestPermission() async => permissionRequests++;

  @override
  Future<void> scheduleFor(RecurringPayment payment) async {
    scheduled.add(payment);
    if (failScheduling) throw StateError('notifications unavailable');
  }
}
