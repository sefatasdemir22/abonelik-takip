import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'domain dosyaları Flutter, Drift veya platform eklentilerini import etmez',
    () {
      final domainFiles = Directory('lib')
          .listSync(recursive: true)
          .whereType<File>()
          .where(
            (file) =>
                file.path.endsWith('.dart') &&
                file.path.replaceAll('\\', '/').contains('/domain/'),
          );
      const forbidden = [
        "package:flutter/",
        "package:drift/",
        "package:flutter_local_notifications/",
        "package:flutter_timezone/",
      ];
      for (final file in domainFiles) {
        final source = file.readAsStringSync();
        for (final import in forbidden) {
          expect(
            source,
            isNot(contains(import)),
            reason: '${file.path}: $import',
          );
        }
      }
    },
  );

  test('presentation ve data bağımlılık yönünü tersine çeviremez', () {
    final dartFiles = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));
    for (final file in dartFiles) {
      final normalized = file.path.replaceAll('\\', '/');
      final source = file.readAsStringSync();
      if (normalized.contains('/presentation/')) {
        expect(source, isNot(contains('/data/')), reason: file.path);
        expect(source, isNot(contains('package:drift/')), reason: file.path);
        expect(
          source,
          isNot(contains('flutter_local_notifications')),
          reason: file.path,
        );
        expect(source, isNot(contains('/app/')), reason: file.path);
      }
      if (normalized.contains('/data/')) {
        expect(source, isNot(contains('/presentation/')), reason: file.path);
      }
    }
  });
}
