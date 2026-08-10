import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../../core/domain/local_date.dart';
import '../../features/notifications/domain/notification_scheduler.dart';
import '../../features/recurring_payments/domain/recurring_payment.dart';

final class AndroidNotificationScheduler implements NotificationScheduler {
  AndroidNotificationScheduler({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static const _details = NotificationDetails(
    android: AndroidNotificationDetails(
      'upcoming_payments',
      'Yaklaşan ödemeler',
      channelDescription: 'Yaklaşan düzenli ödeme hatırlatmaları',
      importance: Importance.high,
      priority: Priority.high,
    ),
  );

  final FlutterLocalNotificationsPlugin _plugin;

  @override
  Future<void> initialize() async {
    tz_data.initializeTimeZones();
    final zone = await FlutterTimezone.getLocalTimezone();
    final identifier = zone.identifier.trim();
    final normalizedIdentifier = identifier.toLowerCase();
    tz.Location location;
    if (normalizedIdentifier == 'gmt' ||
        normalizedIdentifier == 'utc' ||
        normalizedIdentifier == 'etc/utc' ||
        normalizedIdentifier == 'etc/gmt') {
      location = tz.UTC;
    } else {
      try {
        location = tz.getLocation(identifier);
      } on tz.LocationNotFoundException {
        location = tz.UTC;
      }
    }
    tz.setLocalLocation(location);
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
  }

  @override
  Future<void> requestPermission() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  @override
  Future<void> scheduleFor(RecurringPayment payment) async {
    final due = payment.nextPaymentDate;
    await _schedule(
      id: _notificationId(payment.id, 1),
      date: due.addDays(-3),
      hour: 10,
      title: '${payment.name} ödemesi yaklaşıyor',
      body: 'Ödeme tarihine 3 gün kaldı.',
      payload: payment.id,
    );
    await _schedule(
      id: _notificationId(payment.id, 2),
      date: due,
      hour: 9,
      title: '${payment.name} bugün ödenecek',
      body: 'Ödemeyi yaptıktan sonra durumunu onaylayabilirsin.',
      payload: payment.id,
    );
  }

  Future<void> _schedule({
    required int id,
    required LocalDate date,
    required int hour,
    required String title,
    required String body,
    required String payload,
  }) async {
    final scheduled = tz.TZDateTime(
      tz.local,
      date.year,
      date.month,
      date.day,
      hour,
    );
    if (!scheduled.isAfter(tz.TZDateTime.now(tz.local))) return;
    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduled,
      notificationDetails: _details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: payload,
    );
  }

  @override
  Future<void> cancelForOccurrence(String recurringPaymentId) async {
    await _plugin.cancel(id: _notificationId(recurringPaymentId, 1));
    await _plugin.cancel(id: _notificationId(recurringPaymentId, 2));
  }

  int _notificationId(String value, int suffix) {
    var hash = 0x811c9dc5;
    for (final unit in value.codeUnits) {
      hash = ((hash ^ unit) * 0x01000193) & 0x7fffffff;
    }
    return ((hash & 0x0fffffff) * 10 + suffix) & 0x7fffffff;
  }
}
