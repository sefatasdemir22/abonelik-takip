# ADR 0002 — Local-first Drift repository

- Durum: Kabul edildi
- Tarih: 3 Ağustos 2026

## Karar

Drift/SQLite yerel ana veri kaynağıdır. Presentation yalnız repository portlarını kullanır; Drift tipleri domain veya UI katmanına sızmaz.

## Sonuçlar

Repository contract testleri in-memory ve Drift adapter'larında aynı davranışı doğrular. Migration ve şifreleme spike'ı kalıcı mağaza şeması için kalite kapısıdır.

