# Abonelik Takip

Kişisel ve paylaşılan abonelikleri, yaklaşan ödemeleri, kişiler arası hesaplaşmaları ve ileride aile finans alanını tek bir mobil uygulamada yönetmeyi hedefleyen Android-first, local-first Flutter projesi.

Proje aktif geliştirme aşamasındadır. Mevcut UI çalışan erken prototiptir ve final tasarım değildir. Ana odak şu anda personal subscriptions / kişisel aboneliklerdir.

**Current roadmap task:** M2.1 — Aboneliklerim > Kişisel gerçek liste

## Ürün yönü

- Kişisel abonelik takibi
- Paylaşılan abonelikler
- Hesaplaşma
- İleride aile finans alanı
- Sade analiz/read model'leri

Bu proje genel amaçlı bir banka veya bütçe uygulaması değildir.

## Mevcut durum

- Flutter / Android foundation
- `Money` domain primitive
- Monthly/yearly `BillingSchedule`
- Drift local persistence
- Recurring payment creation flow
- 5-item application navigation
- Light/dark visual foundation

## Kanonik belgeler

- [docs/PRODUCT.md](docs/PRODUCT.md) — ürün kapsamı ve UX kararları
- [docs/ROADMAP.md](docs/ROADMAP.md) — geliştirme sırası
- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) — teknik mimari
- [AGENTS.md](AGENTS.md) — agent/Codex çalışma kuralları

## Development

Kurulum ve geliştirme adımları [docs/development/setup.md](docs/development/setup.md) içinde yer alır.

## Şimdilik kapsam dışında

- Auth/cloud sync
- Bank integration
- Automatic payment verification
- FX conversion
- Investment/crypto
