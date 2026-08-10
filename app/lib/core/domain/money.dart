int parseMinorUnits(String input) {
  final normalized = input.trim().replaceAll(',', '.');
  if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(normalized)) {
    throw const FormatException('Tutar en fazla iki ondalık basamak içermeli.');
  }
  final parts = normalized.split('.');
  final whole = int.parse(parts[0]);
  final fraction = parts.length == 1 ? '00' : parts[1].padRight(2, '0');
  return whole * 100 + int.parse(fraction);
}

String formatMinorUnits(int value) {
  final whole = value ~/ 100;
  final fraction = (value % 100).toString().padLeft(2, '0');
  return '$whole,$fraction';
}

final class Money {
  Money({required int minorUnits, required String currencyCode})
    : minorUnits = _validateMinorUnits(minorUnits),
      currencyCode = _normalizeCurrencyCode(currencyCode);

  factory Money.zero(String currencyCode) =>
      Money(minorUnits: 0, currencyCode: currencyCode);

  final int minorUnits;
  final String currencyCode;

  Money operator +(Money other) {
    _requireSameCurrency(other);
    return Money(
      minorUnits: minorUnits + other.minorUnits,
      currencyCode: currencyCode,
    );
  }

  Money operator -(Money other) {
    _requireSameCurrency(other);
    final difference = minorUnits - other.minorUnits;
    if (difference < 0) {
      throw StateError('Money subtraction cannot produce a negative amount.');
    }
    return Money(minorUnits: difference, currencyCode: currencyCode);
  }

  void _requireSameCurrency(Money other) {
    if (currencyCode != other.currencyCode) {
      throw ArgumentError('Money currencies must match.');
    }
  }

  static int _validateMinorUnits(int value) {
    if (value < 0) {
      throw ArgumentError.value(value, 'minorUnits', 'Cannot be negative.');
    }
    return value;
  }

  static String _normalizeCurrencyCode(String value) {
    final normalized = value.trim().toUpperCase();
    if (!RegExp(r'^[A-Z]{3}$').hasMatch(normalized)) {
      throw ArgumentError.value(
        value,
        'currencyCode',
        'Must contain exactly three ASCII letters.',
      );
    }
    return normalized;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Money &&
          minorUnits == other.minorUnits &&
          currencyCode == other.currencyCode;

  @override
  int get hashCode => Object.hash(minorUnits, currencyCode);
}
