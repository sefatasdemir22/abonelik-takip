# Ürün Tanımı ve Kararları

Bu belge, “Ne yapıyoruz, neden yapıyoruz, UX ve ürün sınırlarımız neler?” sorusunun kanonik cevabıdır. Uygulama sırası için [ROADMAP.md](ROADMAP.md), teknik uygulama ilkeleri için [ARCHITECTURE.md](ARCHITECTURE.md) kullanılmalıdır.

## Ürün kimliği

Ürün; kişisel abonelik takibini, paylaşılan abonelikleri, kişiler arası hesaplaşmayı, aile finans alanını ve sade analizleri tek bir görsel kontrol merkezinde birleştirir. Genel amaçlı klasik bütçe veya harcama uygulamasına dönüşmemelidir.

Temel değer önerisi, kullanıcının kişisel ve ortak aboneliklerini, yaklaşan ödemelerini, kimden alacağı veya kime ödeyeceği tutarları ve ileride aile finans durumunu tek, sade ve anlaşılır bir merkezden yönetebilmesidir.

## Ana navigasyon

Kanonik alt navigasyon sırası:

1. Aboneliklerim
2. Ailem
3. Ana Sayfa
4. Hesaplaşma
5. Profil

Ana Sayfa ortadadır ve diğer sekmelerden görsel olarak daha belirgindir. Analiz bir alt navigasyon hedefi değildir; Ana Sayfa içindeki kısayoldan açılır.

## Ekran sorumlulukları

### Aboneliklerim

Abonelik oluşturma ve yönetme alanıdır. `Kişisel | Paylaşılan` ayrımı korunur.

Kişisel alanın hedefleri:

- Abonelik listesi ve ekleme
- Detay ve düzenleme
- Pasife alma veya silme
- İleride ödeme geçmişi

Paylaşılan alanın hedefleri:

- Shared subscription yönetimi
- Katılımcılar ve paylar
- Ödeme durumları

Ana Sayfa üzerinde abonelik oluşturulmaz.

### Ana Sayfa

Creation/manage ekranı değil, read-oriented kontrol merkezidir. Temel içerikleri:

- Sıradaki ödeme
- Para birimi bazında aylık özet
- Onay bekleyenler
- Yaklaşan abonelikler
- Analiz, Ailem ve Hesaplaşma drill-down kısayolları

Sağ üstte küçük ve dolgun bir “Ana Sayfa görünümü” kontrolü bulunabilir. Kısa vadede gerçek işlevi Sistem, Açık ve Koyu tema seçimidir. İleride widget göster/gizle, yoğunluk, kart sıralama ve ana sayfa düzeni burada yönetilebilir.

### Ailem

Aile bağlamındaki finans alanıdır. Gelecekte aile üyeleri, ortak bütçe, aile abonelikleri ve ortak giderleri sunacaktır.

Aile abonelikleri için duplicate subscription domain oluşturulmaz. Aileye bağlı shared subscription, aynı temel domain verisinin Ailem içindeki projection/view görünümüdür. Ailem yalnız aile bağlamına ait verileri ve görünümleri sahiplenir.

### Hesaplaşma

Kişiler arası finansal yükümlülüklerin görünümüdür. Gelecekte sana ödenecekleri, senin ödeyeceklerini, bekleyen ve tamamlanan hesaplaşmaları ve kişi bazlı durumu gösterecektir.

Hesaplaşma yalnız aileye özel değildir; arkadaşlar, paylaşılan abonelikler ve uygun diğer ortak giderler de borç/alacak üretebilir.

### Profil

Kalıcı kullanıcı ve uygulama tercihlerinin alanıdır. Auth bulunmadığı sürece sahte kullanıcı adı, avatar veya hesap bilgisi gösterilmez.

Planlanan gruplar:

- Görünüm: tema ve ana sayfa düzeni
- Bildirimler: ödeme hatırlatmaları
- Tercihler: varsayılan uygulama tercihleri
- Uygulama: hakkında, sürüm ve lisanslar

Auth geldiğinde profile/account alanı buraya eklenir.

### Analiz

Ana navigasyon hedefi değil, Ana Sayfa’dan açılan read-only analiz ekranıdır. Aylık abonelik yükü, yıllık tahmini yük, kategori dağılımı, en pahalı abonelikler, yaklaşan yük ve ileride shared/settlement/family read model’lerini gösterebilir.

Analiz business logic’in sahibi değildir; projection/read model tüketir.

## Ailem, Paylaşılan ve Hesaplaşma sınırı

- **Paylaşılan abonelik**, recurring subscription’ın kimler arasında ve hangi paylarla paylaşıldığını tanımlar.
- **Ailem**, aile grubunun bağlamını, üyelerini ve aileye ait finansal görünümleri sunar.
- **Hesaplaşma**, shared subscription veya uygun ortak giderlerden doğan kişiler arası borç/alacak sonuçlarını gösterir.

Örnekler:

- Netflix arkadaşlarla paylaşılmışsa Aboneliklerim > Paylaşılan’da yönetilir; borç/alacak sonucu Hesaplaşma’da görünür.
- Netflix aile grubuna bağlıysa temel shared subscription Aboneliklerim > Paylaşılan altında bulunabilir; Ailem > Aile abonelikleri altında aynı verinin aile projection’ı gösterilebilir; borç/alacak sonucu Hesaplaşma’da yer alabilir.

Aynı subscription veya finansal sonuç farklı feature’lar için kopyalanmaz.

## Personal subscription UX

V1 minimum billing cadence değerleri `monthly` ve `yearly`’dir. Weekly ve custom interval V1 kapsamı dışındadır.

Temel bilgiler:

- Ad
- Minor-unit tutar
- ISO para birimi kodu
- Sonraki ödeme tarihi
- Billing cadence
- Kategori
- İsteğe bağlı ödeme yöntemi nickname

## Shared subscription UX kararları

V1 paylaşım türleri `equal`, `fixed` ve `percentage` olacaktır. Payların minor-unit toplamı subscription toplamıyla tam eşleşmelidir. Bölünemeyen remainder deterministik biçimde payer’a atanabilir.

Ödeme durumları `pending`, `paid` ve `waived` olacaktır. Partial payment V1’de yoktur. Local-first aşamada katılımcılar `AppUser` değil `LocalPerson` olacaktır.

Shared occurrence, fiyatı, payer’ı ve üye paylarını immutable snapshot olarak saklar. Üyeler beklenen payları ve subscription payment status bilgisini görebilir; başka kişilerin özel finansal detayları gösterilmez.

## Para birimi kuralları

Farklı currency değerleri asla toplanmaz. TRY ve USD için birleşik toplam veya FX conversion yoktur.

Doğru sunum örneği:

```text
120 TRY
10 USD
```

## Logo ve marka görselleri

Abonelik servisleri için logo desteği planlanmaktadır; provider henüz seçilmemiştir. Araştırmada açık/uygun lisans, trademark koşulları, güvenilirlik, rate limit, maliyet ve cache politikası değerlendirilmelidir.

Mimari hedef değiştirilebilir bir `LogoProvider` abstraction’ıdır. Domain belirli bir logo API URL’sine bağımlı olmaz. Logo bulunamazsa initials veya generic service icon fallback’i kullanılır; logolar mümkün olduğunca cache’lenir.

## Ana Sayfa stacked subscription deck

Planlanan imza UX bileşenidir. Abonelikler arttığında düz listeye ek veya alternatif olarak üst üste duran kart destesi kullanılabilir.

Beklenen davranış:

- Tıklama veya swipe ile sıradaki kart öne gelir.
- Son karttan sonra ilk karta dönen loop bulunur.
- Animasyon kısa ve akıcıdır.
- Kart ad/logo, fiyat/currency, ödeme tarihi, cadence ve gerektiğinde kalan günü gösterir.
- Hareket performansı veya erişilebilirliği bozmaz.

## Görsel dil

- Dark: graphite/charcoal ve kontrollü turuncu accent
- Light: off-white/stone, graphite metin ve kontrollü turuncu accent
- Dark theme ana görsel referanstır.
- Light theme nötrdür; büyük yüzeylerde pastel peach/pembe baskın olmaz.
- Büyük radius, dolgun surface, bubble/pill, hafif depth ve kontrollü mikro animasyonlar kullanılır.

Neon, ağır glassmorphism, aşırı blur, aşırı gradient ve çocuk uygulaması görünümü kullanılmaz.

## Gamification — ileri dönem keşif fikri

Bu özellik şimdi uygulanmayacaktır. Uzun vadede zamanında ödeme, hesaplaşma tamamlama, bütçe/hedef başarısı veya tasarruf serisi gibi sağlıklı davranışlardan sanal XP/kredi kazanılan kozmetik bir koleksiyon/achievement sistemi araştırılabilir.

Kurallar:

- Gerçek para değeri ve cash-out yoktur.
- Gerçek para ile loot box satın alma yoktur.
- Kumar mekaniğine dönüşmez.
- Daha fazla harcamayı teşvik etmez.
- Finansal olarak sağlıklı davranışları destekleyen yan sistemdir.

## V1 ve kısa vadede yapılmayacaklar

- Bankadan para transferi veya banka hesabı bağlantısı
- Otomatik ödeme doğrulama veya kredi kartı entegrasyonu
- FX/currency conversion
- Debt simplification
- Partial payment
- Kişisel gelir tracking veya genel amaçlı bütçe sistemi
- Yatırım veya kripto
- Auth, cloud sync ve gerçek invite sistemi

Aile bütçesi daha sonraki ayrı milestone’da, sade ve açık bir bağlamla ele alınacaktır.
