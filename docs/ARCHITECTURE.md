# Teknik Mimari ve Geliştirme Kuralları

Bu belge “Özelliği nasıl implement etmeliyiz?” sorusunun kanonik cevabıdır. Ürün kararları için [PRODUCT.md](PRODUCT.md), uygulama sırası için [ROADMAP.md](ROADMAP.md), agent çalışma kuralları için [../AGENTS.md](../AGENTS.md) kullanılır.

## Architectural direction

```text
Presentation
    ↓
Application
    ↓
Domain
```

Repository interface’leri domain/application sınırında bulunur. Data adapter’ları bu interface’leri implement eder. Platform ve external dependency’ler presentation veya domain katmanına sızmaz.

## Feature boundaries

Feature’lar birbirinin presentation katmanına bağımlı olmamalıdır. Örneğin `SubscriptionsScreen`, `DashboardScreen` veya `DashboardController` import etmez.

Cross-feature refresh ve navigation orchestration app shell/composition seviyesinde çözülür. Recurring payment eklendiğinde Subscriptions başarı callback’i verir; `AppShell` Dashboard reload’unu tetikler. Application use-case içine Dashboard side effect’i gizlenmez.

Gelecekte gerekebilir düşüncesiyle abstraction oluşturulmaz; yalnız mevcut ve doğrulanmış sınırlar modellenir.

## Current feature organization

Gerçek kaynak yapısının kısa haritası:

```text
app/lib/
├── app/                  # composition root, providers, shell ve theme
├── core/
│   ├── domain/           # AppClock, LocalDate, Money, BillingSchedule
│   ├── persistence/      # Drift AppDatabase ve generated code
│   └── security/         # DatabaseKeyStore portu
├── features/
│   ├── analysis/presentation/
│   ├── dashboard/presentation/
│   ├── family/presentation/
│   ├── notifications/domain/
│   ├── payment_occurrences/{domain,data}/
│   ├── profile/presentation/
│   ├── recurring_payments/{domain,application,data,presentation}/
│   ├── settlements/presentation/
│   └── subscriptions/presentation/
└── integrations/
    ├── notifications/
    └── security/
```

## Domain primitives

### Money

`Money`, tutarı `int minorUnits` ve normalize edilmiş üç harfli ISO currency code ile taşır. `double` ile para matematiği yapılmaz. Farklı currency işlemleri reddedilir, negatif tutar veya negatif çıkarma sonucu kabul edilmez ve FX yoktur.

Mevcut demo uyumluluğu için `money.dart` içinde legacy `parseMinorUnits` ve `formatMinorUnits` yardımcıları da korunmaktadır. Bu yardımcıların iki ondalık varsayımı `Money` primitive’inin genel minor-unit semantiği değildir.

### LocalDate

Takvim günü ifade eden iş kavramlarında kullanılır. Payment due date UTC timestamp değildir; `LocalDate` olarak modellenir.

### UTC timestamps

`createdAtUtc` ve `confirmedAtUtc` gibi gerçek anlar UTC timestamp semantiği taşır. İş tarihleriyle timestamp’ler birbirine karıştırılmaz.

### BillingSchedule

`monthly` ve `yearly` cadence destekler ve geçici clamp edilmiş tarihten değil anchor’dan ilerler.

- Monthly: 31 Ocak → Şubat’ın son günü → Mart’ta yeniden 31
- Yearly: 29 Şubat → artık olmayan yılda 28 Şubat → sonraki artık yılda yeniden 29 Şubat

Bu davranışlar domain testleriyle korunur.

## Recurring payment creation

Hedef ve mevcut akış:

```text
Subscriptions presentation
    ↓
AddRecurringPayment application use-case
    ↓
RecurringPaymentRepository + NotificationScheduler
```

`AddRecurringPayment`; UUID üretimi, input normalizasyonu, `BillingSchedule` oluşturma, repository kaydı, notification izni ve planlamasını orkestre eder. Dialog yalnız form state’i ve validation taşır. Dashboard creation sorumluluğuna sahip değildir.

## Dashboard

Dashboard read/projection oriented kontrol merkezidir. Geçici olarak occurrence materialization, load ve mutation sorumlulukları `DashboardController` içinde bulunabilir; buraya yeni business logic eklenmemelidir.

Planlanan cleanup, occurrence materialization ve mutation akışlarını application service’lere taşımaktır.

## Personal occurrence ve shared occurrence

Mevcut `PaymentOccurrence` yalnız personal recurring payment içindir. Shared subscription occurrence ayrı aggregate/model olmalıdır; ikisi tek modelde zorla birleştirilmez.

Shared occurrence fiyat, payer ve member share bilgilerini immutable snapshot olarak saklar.

## Persistence

Yerel veri kaynağı Drift’tir. Veritabanı açılışı encrypted SQLite sağlayıcısını doğrulayan hook ve platform `DatabaseKeyStore` adapter’ı kullanır.

Migration’lar additive ve veri koruyan biçimde yazılır. Yeni sürümlerde v1→v2→v3 gibi zincirlerin çalışması düşünülür. Drift generated dosyaları elle değiştirilmez. Migration schema snapshot’ları ve `SchemaVerifier` veri bütünlüğü testleriyle doğrulanır.

## Repository boundaries

Repository interface persistence ayrıntısı sızdırmamalıdır. Örneğin `updateNextPaymentDate(String id, String nextDateIso)` mevcut geçiş API’sidir; uzun vadede gereksiz ISO string sızıntısı temizlenmelidir.

Business rule’lar Drift repository içine taşınmaz. Repository, domain ile persistence mapping ve veri erişiminden sorumludur.

## Currency rules

Cross-currency sum yoktur. Dashboard ve read model’ler currency bazında gruplar; TRY ve USD ayrı gösterilir. FX engine bulunmaz.

## Local-first

Ürün local-first/offline-first’tür. Şu anda auth, sync, invite backend veya cloud collaboration yoktur. Shared prototype başladığında kimlikler önce `LocalPerson` olacaktır. Cloud ayrı ve ileri bir milestone’dır.

## Subscription logo architecture

Provider seçilmemiştir. Gelecek akış:

```text
LogoProvider → network provider → cache → fallback
```

Domain, provider’a özgü remote logo URL’sine bağımlı olmaz. Provider araştırmasında lisans ve trademark koşulları değerlendirilir. Binlerce marka görseli uygulamaya gömülmez.

## Family/shared/settlement data ownership

- `SharedSubscription`: paylaşım configuration’ı
- Family: grup bağlamı ve family projection’ları
- Settlement: türetilmiş kişiler arası obligation/read model
- Analysis: projection/read model consumer
- Dashboard: cross-feature summary consumer

Aynı business entity farklı feature’larda duplicate edilmez.

## UI architecture

Material 3 tabanı korunur.

- Dark graphite/charcoal
- Light stone/off-white
- Orange accent
- Bubble/pill surface’ler ve hafif depth
- En az yaklaşık 48 dp touch target
- Status yalnız renkle anlatılmaz

Ana navigasyon Aboneliklerim / Ailem / Ana Sayfa / Hesaplaşma / Profil sırasındadır. Ana Sayfa merkez hedeftir; Analiz Ana Sayfa’dan açılır.

## Animation rules

Animasyonlar kısa, amaçlı ve etkileşimi engellemeyen nitelikte olmalıdır. Ağır animation library ancak Flutter primitive’leri yetersizse ve ölçülmüş gerekçe varsa eklenir. Reduced-motion desteği geldiğinde saygı gösterilir.

Stacked subscription deck performans ve erişilebilirlik pahasına gösterişli hareket kullanmaz.

## App size ve performance disiplini

Feature code tek başına ana boyut riski değildir. Bundled video, gereksiz büyük audio, dev raster asset ve gerekçesiz ağır SDK’dan kaçınılır.

Logo için network/cache/fallback, binlerce bundled marka asset’ine tercih edilir. Gelecek collectible kartlarda yüzlerce sıkıştırılmamış yüksek çözünürlüklü asset gömülmez.

Önemli asset veya native SDK değişikliklerinden sonra periyodik olarak ölçülür:

```text
flutter build apk --release --split-per-abi
flutter build appbundle --release
```

Erken optimizasyon yapılmaz; release çıktısı izlenir.

## Notifications

`NotificationScheduler` abstraction’ı korunur. Recurring payment oluşturulurken bildirim izni ve planlama application workflow’a aittir; UI widget’ına veya domain’e taşınmaz. Hassas kullanıcı verisi loglanmaz.

## Testing

- Domain primitive’leri unit test ister.
- Application use-case’leri focused test ister.
- Persistence migration’ları schema migration ve data-integrity testleri ister.
- Widget testleri pixel-perfect styling yerine anlamlı kullanıcı akışlarını doğrular.
- Refactor geçirmek için test silinmez veya beklentiler zayıflatılmaz.
- Golden test yalnız daha sonra açık gerekçe varsa eklenir.

## Codex working rules summary

Kanonik execution kuralları [../AGENTS.md](../AGENTS.md) içindedir. Temel mimari özet:

- Dar kapsamla çalış.
- Gerekçe olmadan repo-wide tarama yapma.
- Onaysız dependency değiştirme.
- Alakasız refactor yapma.
- Generated dosyaları elle değiştirme.
- Değişen Dart dosyalarını formatla.
- Dar görevlerde targeted test kullan.
- Milestone checkpoint’lerinde geniş doğrulama çalıştır.

## Erken uygulanmayacak gelecekteki karmaşıklık

Roadmap ilgili milestone’a gelmeden auth abstraction, sync engine, backend, FX engine, bank integration, generic budgeting engine, plugin system, gamification model, family domain veya shared domain eklenmez.
