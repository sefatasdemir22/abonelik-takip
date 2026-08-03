# ADR-0006: Şifreli yerel veritabanı ve anahtar yaşam döngüsü

- Durum: Kabul edildi
- Tarih: 3 Ağustos 2026

## Karar

Drift veritabanı, `sqlite3` hook’u üzerinden SQLite3MultipleCiphers ile açılır. İlk çalıştırmada `Random.secure()` ile 256 bit rastgele veritabanı anahtarı üretilir. Anahtar uygulama dosyalarına yazılmaz; `flutter_secure_storage` Android adapter’ı aracılığıyla Android Keystore tarafından korunan AES-GCM/RSA-OAEP depoda tutulur.

Android otomatik yedekleme kapalıdır. Anahtar yoksa mevcut şifreli veritabanına sessizce yeni anahtar uygulanmaz; açılış başarısız olur ve veri kaybına yol açabilecek otomatik sıfırlama yapılmaz.

## Sonuçlar

- Minimum Android SDK 23’tür.
- Uygulama kaldırıldığında Keystore anahtarı da kaybolabileceği için kullanıcıya taşınabilir şifreli export sunulmadan cihaz yedeği vaadi verilmez.
- Export anahtarı veritabanı anahtarından ayrı olacaktır.
- Cipher varlığı veritabanı açılışında doğrulanır.
