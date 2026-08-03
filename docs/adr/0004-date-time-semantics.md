# ADR 0004 — Tarih ve zaman semantiği

- Durum: Kabul edildi
- Tarih: 3 Ağustos 2026

## Karar

- Ödeme/vade tarihleri saat dilimsiz `LocalDate` değerleridir.
- Kullanıcı bildirim saatleri `LocalTime` değerleridir.
- Oluşturma, onay ve denetim zamanları UTC `Instant` değerleridir.
- Saat dilimi değişikliği iş tarihlerini değiştirmez; yalnız platform bildirimleri yeniden planlanır.

