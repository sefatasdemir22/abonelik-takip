import 'package:abonelik_takip/core/domain/money.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Money', () {
    test('currency code uppercase olarak normalize edilir', () {
      expect(Money(minorUnits: 100, currencyCode: 'try').currencyCode, 'TRY');
    });

    test('currency code whitespace temizlenerek normalize edilir', () {
      expect(
        Money(minorUnits: 100, currencyCode: '  usd\t').currencyCode,
        'USD',
      );
    });

    test('negatif minor unit reddedilir', () {
      expect(
        () => Money(minorUnits: -1, currencyCode: 'TRY'),
        throwsArgumentError,
      );
    });

    test('gecersiz currency code reddedilir', () {
      for (final code in ['TR', 'TRY1', 'TR₺', '123']) {
        expect(
          () => Money(minorUnits: 100, currencyCode: code),
          throwsArgumentError,
        );
      }
    });

    test('ayni currency tutarlari toplanir', () {
      expect(
        Money(minorUnits: 120, currencyCode: 'TRY') +
            Money(minorUnits: 30, currencyCode: 'try'),
        Money(minorUnits: 150, currencyCode: 'TRY'),
      );
    });

    test('farkli currency tutarlari toplanamaz', () {
      expect(
        () =>
            Money(minorUnits: 120, currencyCode: 'TRY') +
            Money(minorUnits: 30, currencyCode: 'USD'),
        throwsArgumentError,
      );
    });

    test('ayni currency tutarlari cikarilir', () {
      expect(
        Money(minorUnits: 120, currencyCode: 'TRY') -
            Money(minorUnits: 30, currencyCode: 'try'),
        Money(minorUnits: 90, currencyCode: 'TRY'),
      );
    });

    test('negatif sonuclu cikarma reddedilir', () {
      expect(
        () =>
            Money(minorUnits: 30, currencyCode: 'TRY') -
            Money(minorUnits: 120, currencyCode: 'TRY'),
        throwsStateError,
      );
    });

    test('farkli currency tutarlari cikarilamaz', () {
      expect(
        () =>
            Money(minorUnits: 120, currencyCode: 'TRY') -
            Money(minorUnits: 30, currencyCode: 'USD'),
        throwsArgumentError,
      );
    });

    test('value equality ve hashCode ayni degerler icin esittir', () {
      final first = Money(minorUnits: 150, currencyCode: 'try');
      final second = Money(minorUnits: 150, currencyCode: 'TRY');

      expect(first, second);
      expect(first.hashCode, second.hashCode);
      expect(first, isNot(Money(minorUnits: 151, currencyCode: 'TRY')));
      expect(first, isNot(Money(minorUnits: 150, currencyCode: 'USD')));
    });

    test('zero factory sifir tutar olusturur', () {
      expect(Money.zero(' eur '), Money(minorUnits: 0, currencyCode: 'EUR'));
    });
  });
}
