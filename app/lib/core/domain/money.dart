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
