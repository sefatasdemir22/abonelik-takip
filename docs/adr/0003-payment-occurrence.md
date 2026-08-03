# ADR 0003 — PaymentOccurrence yaşam döngüsü

- Durum: Kabul edildi
- Tarih: 3 Ağustos 2026

## Karar

Gelecek dönemler sanal hesaplanır. Vade günü occurrence kalıcılaştırılır ve kullanıcı onayına kadar `awaitingConfirmation` kalır. Kullanıcı yalnız `paid` veya `skipped` sonucunu oluşturur; tarihin geçmesi ödeme kanıtı değildir.

`recurringPaymentId + expectedDate` occurrence anahtarı benzersizdir.

