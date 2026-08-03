# Çalışma kuralları

## Başlamadan önce

1. `PLAN.md` ve `docs/project/current-status.md` dosyalarını oku.
2. İlgili feature, test, sözleşme ve ADR'leri incele.
3. Mevcut yardımcıları ve repository'leri ara.
4. Onaylanmış mimariyi sessizce değiştirme.

## Zorunlu sınırlar

- Presentation doğrudan Drift, platform SDK'sı veya harici servis çağırmaz.
- Domain yalnız saf Dart ve domain primitive'lerine bağlıdır.
- Para `double` ile tutulmaz; minor-unit tamsayı ve ISO 4217 kodu kullanılır.
- İş tarihleri `LocalDate`, denetim zamanları UTC `Instant` semantiğindedir.
- Hassas kullanıcı verisi log veya analitiğe yazılmaz.
- Yeni bağımlılık gerekçesiz eklenmez.
- Supabase, auth, iOS, kur dönüşümü ve entitlement bu aşamada oluşturulmaz.
- Test silerek hata çözülmez.

## Bitirmeden önce

- Format, analyze, unit/widget test ve Android debug build çalıştır.
- Dependency sınırı ve repository contract testlerini çalıştır.
- Veri modeli değiştiyse migration testi ekle.
- Aşama gerçekten değiştiyse `docs/project/current-status.md` dosyasını güncelle.

