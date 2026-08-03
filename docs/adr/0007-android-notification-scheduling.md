# ADR-0007: Android yerel bildirim zamanlaması

- Durum: Kabul edildi
- Tarih: 3 Ağustos 2026

## Karar

Domain yalnız `NotificationScheduler` portunu bilir. Android adapter’ı `flutter_local_notifications` kullanır, cihazın IANA saat dilimini çözer ve bildirimleri `inexactAllowWhileIdle` ile planlar. Çekirdek dilimde vade öncesi üç gün saat 10:00 ve vade günü saat 09:00 varsayımları kullanılır.

Kesin alarm izni istenmez. Android 13+ bildirim izni yalnız kullanıcının ilk ödeme ekleme eyleminden sonra talep edilir. Boot receiver planlanmış bildirimlerin cihaz yeniden başlatıldığında kurulabilmesini sağlar.

## Sonuçlar

- Kesin saat garantisi verilmez; batarya politikaları gecikmeye neden olabilir.
- Ödeme onaylandığında ilgili dönem bildirimleri iptal edilir.
- Saat dilimi/DST ve cihaz yeniden başlatma davranışı fiziksel cihaz matrisinde ayrıca doğrulanır.
