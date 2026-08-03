import 'local_date.dart';

abstract interface class AppClock {
  DateTime nowUtc();
  LocalDate todayLocal();
}

final class SystemAppClock implements AppClock {
  const SystemAppClock();

  @override
  DateTime nowUtc() => DateTime.now().toUtc();

  @override
  LocalDate todayLocal() => LocalDate.fromDateTime(DateTime.now());
}

final class FakeAppClock implements AppClock {
  FakeAppClock(this._localNow);

  DateTime _localNow;

  void setLocal(DateTime value) => _localNow = value;

  void advance(Duration duration) => _localNow = _localNow.add(duration);

  @override
  DateTime nowUtc() => _localNow.toUtc();

  @override
  LocalDate todayLocal() => LocalDate.fromDateTime(_localNow);
}
