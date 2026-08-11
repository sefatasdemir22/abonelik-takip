# Ürün ve Geliştirme Yol Haritası

Last updated: 2026-08-10

Current focus: **M2 — Personal subscriptions**

Next concrete task: **M2.2 — Subscription detail screen**

Bu belge “Şimdi ne yapıyoruz, sırada ne var?” sorusunun kanonik cevabıdır. Ürün kapsamı için [PRODUCT.md](PRODUCT.md), uygulama kuralları için [ARCHITECTURE.md](ARCHITECTURE.md) kullanılır.

## M0 — Foundation

- [x] `Money` domain primitive
- [x] `BillingSchedule` domain primitive
- [x] Drift schema v1→v2 additive migration ve veri bütünlüğü testi
- [x] Personal recurring payment `BillingSchedule` entegrasyonu
- [x] Aylık/yıllık billing cadence seçimi

## M1 — App shell and visual foundation

- [x] Beşli navigasyon: Aboneliklerim / Ailem / Ana Sayfa / Hesaplaşma / Profil
- [x] Graphite dark ve stone light theme
- [x] Dashboard görsel ve bilgi mimarisi revizyonu
- [x] Family, settlements ve profile presentation shell’leri
- [x] Analiz kısayolunun Ana Sayfa’ya taşınması
- [x] Recurring payment creation sorumluluğunun Dashboard’dan ayrılması

## M2 — Personal subscriptions

- [x] **M2.1 Aboneliklerim > Kişisel gerçek liste**
  - Repository/read data
  - Empty ve populated state
  - Ad
  - Tutar ve currency
  - Sonraki ödeme tarihi
  - Monthly/yearly cadence
  - Cross-currency toplam yok
- [ ] **M2.2** Subscription detail screen
- [ ] **M2.3** Edit personal subscription
- [ ] **M2.4** Deactivate/delete semantics
  - Önce hard delete ile inactive/archive arasında semantic karar ver.
  - Geçmiş occurrence kayıtları korunmalıdır.
- [ ] **M2.5** Logo provider research
  - Provider seçilmedi.
  - Lisans, trademark, API güvenilirliği ve maliyet araştırılacak.
- [ ] **M2.6** Logo integration, cache ve fallback
- [ ] **M2.7** Home stacked subscription deck
- [ ] **M2.8** Card deck loop/swipe animation polish

## M3 — Personal payment occurrences

- [ ] Occurrence materialization business logic’ini `DashboardController`’dan çıkar
- [ ] Application service oluştur
- [ ] Payment history
- [ ] Paid/skipped UX
- [ ] Notification preferences
- [ ] Overdue/reminder semantics

## M4 — Shared subscriptions domain

- [ ] `LocalPerson`
- [ ] `SharedSubscription`
- [ ] Payer
- [ ] Equal allocation
- [ ] Fixed allocation
- [ ] Percentage allocation
- [ ] Deterministik minor-unit remainder
- [ ] Occurrence snapshots
- [ ] `pending` / `paid` / `waived`
- [ ] Kapsamlı domain testleri

## M5 — Shared subscriptions UI

- [ ] Shared list
- [ ] Shared create flow
- [ ] Participants
- [ ] Allocation editor
- [ ] Occurrence payment status
- [ ] Social visibility
- [ ] Özel finans verisinin sızmadığını doğrula

## M6 — Settlements

- [ ] Receivable projection
- [ ] Payable projection
- [ ] Person-based view
- [ ] Pending/completed
- [ ] Currency-separated values

## M7 — Family

- [ ] Yalnız ihtiyaç oluştuğunda local family concept/domain
- [ ] Family members
- [ ] Family-linked shared subscription projection
- [ ] Common expenses
- [ ] Simple shared/family budget
- [ ] Family dashboard/read model

Duplicate subscription domain oluşturma.

## M8 — Analysis

- [ ] Gerçek read model’ler
- [ ] Monthly subscription analysis
- [ ] Yearly projection
- [ ] Category distribution
- [ ] Upcoming load
- [ ] Shared/settlement analysis
- [ ] Veri oluştuğunda family analysis

FX aggregation yoktur.

## M9 — Profile and settings

- [ ] Kalıcı tema tercihi
- [ ] Notification settings
- [ ] Default preferences
- [ ] Dashboard customization
- [ ] Dashboard show/hide/order
- [ ] About/licenses

## M10 — Cloud/sync

Yalnız local ürün gerçekten oturduktan sonra:

- [ ] Auth design
- [ ] Sync strategy
- [ ] Real user identities
- [ ] Invites
- [ ] Family membership
- [ ] Shared membership
- [ ] Push notifications

Provider/backend henüz seçilmemiştir.

## M11 — Gamification exploration

Düşük öncelikli ve deneyseldir.

- [ ] Product design
- [ ] Healthy reward rules
- [ ] Virtual XP/credit
- [ ] Collectible cosmetic cards
- [ ] Achievements
- [ ] Accessibility/performance review

Real-money loot box, cash-out ve zararlı finansal teşvik yoktur.

## Cross-cutting quality backlog

- [ ] Release APK/AAB boyut takibi
- [ ] Accessibility
- [ ] Reduced-motion yaklaşımı
- [ ] Empty/error/loading state kalitesi
- [ ] Localization readiness
- [ ] Performance
- [ ] Privacy/security review
- [ ] İleride backup/export stratejisi

## Explicitly rejected / out of scope

- Bank transfer
- Automatic payment verification
- Bank account integration
- FX
- Debt simplification
- Partial payments V1
- Investment/crypto
