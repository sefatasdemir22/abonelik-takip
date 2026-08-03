# ADR-0008: Taşınabilir şifreli export biçimi

- Durum: Kabul edildi; uygulama kodu sonraki export aşamasına aittir
- Tarih: 3 Ağustos 2026

## Karar

Export anahtarı cihaz veritabanı anahtarından bağımsızdır. Kullanıcının yedek parolasından Argon2id ile 256 bit anahtar türetilir. Başlangıç profili:

- Argon2id v1.3
- `m = 65.536 KiB` (64 MiB)
- `t = 3`
- `p = 4`
- 16 bayt kriptografik rastgele salt
- 32 bayt çıktı

Bu profil [RFC 9106’nın düşük bellekli ikinci önerisini](https://www.rfc-editor.org/rfc/rfc9106.html#section-4) izler. Aşama 1 fiziksel cihaz matrisinde süre/bellek benchmark’ı yapılır; daha düşük profil gerekirse OWASP’ın Argon2id alt sınırının altına inilmez ve yeni parametreler dosyanın kendi header’ında taşınır. [OWASP Password Storage Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html#argon2id)

Payload AES-256-GCM ile şifrelenir. Her export için 12 bayt benzersiz ve rastgele nonce, 16 bayt authentication tag kullanılır. 96 bit IV tercihi NIST SP 800-38D ile uyumludur. [NIST SP 800-38D](https://csrc.nist.gov/pubs/sp/800/38/d/final)

## Dosya sözleşmesi

Sürüm 1 container sırası:

```text
8 bayt magic: DOPAY001
4 bayt unsigned big-endian header uzunluğu
UTF-8 JSON header'ın tam baytları
AES-GCM ciphertext
16 bayt authentication tag
```

Header en az `formatVersion`, `schemaVersion`, `createdAtUtc`, `kdf`, KDF parametreleri, base64url salt, `aead`, base64url nonce ve payload içerik türünü taşır. Header’ın tam baytları AES-GCM additional authenticated data olarak doğrulanır; böylece algoritma, parametre veya şema düşürme girişimi bütünlük hatası üretir.

## Güvenlik ve geri yükleme kuralları

- Parola veya türetilmiş anahtar saklanmaz ve loglanmaz.
- Salt ve nonce `Random.secure()` eşdeğeri CSPRNG ile her dosyada yeniden üretilir.
- Parola, tag veya header doğrulaması başarısızsa payload ayrıştırılmaz.
- Geri yükleme önce geçici alanda doğrulanır; mevcut veritabanı ancak tam doğrulama ve kullanıcı onayından sonra tek transaction içinde değiştirilir.
- Android ve iOS aynı test vector’larını geçmeden format yayınlanmaz.
- Kriptografi implementasyonu elde yazılmaz; bakımlı ve denetlenebilir kütüphane seçimi export uygulama aşamasının ayrı bağımlılık incelemesidir.
