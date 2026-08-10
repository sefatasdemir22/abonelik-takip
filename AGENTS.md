# Çalışma kuralları

Bu repo için varsayılan çalışma biçimi dar kapsamlı ve düşük bağlamlıdır.
Gereksiz dosya okuma, geniş repository taraması ve kapsam dışı doğrulama yapma.

## 1. Dar kapsamlı görevler — varsayılan mod

Kullanıcı belirli bir bug, dosya, sınıf veya küçük özellik üzerinde çalışmanı istiyorsa:

1. Yalnız açıkça belirtilen hedef dosyaları incele.
2. Gerekirse yalnız hedefin doğrudan bağımlılıklarını incele.
3. Varsa yalnız doğrudan ilgili testleri incele.
4. Tüm repository'yi tarama.
5. `PLAN.md`, `docs/project/current-status.md` veya diğer genel belgeleri,
   görev bunlara gerçekten ihtiyaç duymuyorsa okuma.
6. Alakasız refactor yapma.
7. Yeni dependency ekleme veya dependency sürümü değiştirme.
8. İstenen kapsam dışındaki dosyaları değiştirme.
9. Değişen Dart dosyalarını formatla.
10. Kullanıcı açıkça istemedikçe aşağıdakileri çalıştırma:
    - tüm `flutter test` suite'i
    - `flutter analyze`
    - Android debug/release build
    - dependency upgrade/outdated kontrolleri
    - tüm repository için geniş doğrulamalar

Görev sonunda yalnız:
- değişen dosyaları,
- yapılan değişikliğin kısa özetini,
- varsa çalıştırılan hedef testlerin sonucunu
bildir.

## 2. Geniş görevler ve milestone çalışmaları

Görev açıkça mimari değişiklik, milestone, kapsamlı feature geliştirmesi,
migration veya genel proje denetimi ise gerekli bağlamı genişletebilirsin.

Bu durumda ihtiyaca göre:
- `PLAN.md`
- `docs/project/current-status.md`
- ilgili ADR'ler
- architecture belgeleri
- repository contract testleri
- dependency boundary testleri

incelenebilir.

Geniş doğrulamalar yalnız bu tür görevlerde veya kullanıcı açıkça istediğinde çalıştırılır.

## 3. Mimari sınırlar

- Presentation doğrudan Drift, platform SDK'sı veya harici servis çağırmaz.
- Domain saf Dart olmalıdır.
- Domain, Flutter veya persistence implementasyonlarına bağımlı olmamalıdır.
- Repository interface'leri domain/application tarafında kalır.
- Drift ve platform implementasyonları adapter/data katmanında kalır.
- Feature'lar başka feature'ların data veya presentation katmanlarına doğrudan bağlanmaz.
- Dashboard ve reports başka domain'lerin sahibi değildir; yalnız read-model/projection tüketir.
- Onaylanmış mimari kullanıcıdan açık onay alınmadan değiştirilmez.

## 4. Domain kuralları

- Para `double` ile tutulmaz.
- Para minor-unit tamsayı ve ISO 4217 para birimi koduyla temsil edilir.
- Farklı para birimleri birbirine eklenmez veya otomatik çevrilmez.
- İş tarihleri `LocalDate` semantiğindedir.
- Denetim/zaman damgaları UTC `Instant` semantiğinde tutulur.
- Geçmiş occurrence kayıtları oluşturulduktan sonra mevcut abonelik ayarlarından etkilenmemelidir.
- Hassas kullanıcı verisi log veya analitiğe yazılmaz.

## 5. Ürün kapsamı sınırları

Açıkça istenmedikçe aşağıdakileri oluşturma:

- Supabase
- auth
- gerçek kullanıcı davet sistemi
- çoklu cihaz sync
- iOS desteği
- kur dönüşümü
- banka entegrasyonu
- banka transferi
- otomatik ödeme doğrulama
- borç sadeleştirme
- grup bütçesi
- kişisel gelir/bütçe modülü

Gelecekte kullanılabilir olabilir diye bugünden kod veya abstraction oluşturma.

## 6. Kod değişikliği ilkeleri

- Önce mevcut çözümü kullan; gereksiz abstraction oluşturma.
- Küçük problem için büyük framework veya yeni katman ekleme.
- Bir işlem için gereksiz yere ayrı use-case dosyaları üretme.
- Yeni dependency ancak açık gerekçe ve kullanıcı onayıyla eklenebilir.
- Test silerek veya gevşeterek hata çözme.
- Generated dosyaları yalnız kaynak şema gerçekten değiştiğinde yeniden üret.
- Kullanıcının istemediği formatting/refactor değişikliklerini başka dosyalara yayma.

## 7. Doğrulama

Dar görevlerde:
- mümkünse yalnız doğrudan ilgili targeted test çalıştırılır;
- geniş test/analyze/build kullanıcı tarafından ayrıca çalıştırılabilir.

Milestone veya commit doğrulamasında gerektiğinde:
- format
- `flutter analyze`
- `flutter test`
- dependency boundary testleri
- repository contract testleri
- migration testleri
- Android debug build

çalıştırılabilir.

Android build her küçük görev için zorunlu değildir.