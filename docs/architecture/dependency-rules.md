# Bağımlılık kuralları

```text
app composition root -> feature presentation/application
feature presentation -> feature domain
feature data -> feature domain
platform integrations -> domain portları
domain -> yalnız saf Dart/domain primitive'leri
```

- Presentation, Drift veya bildirim plugin'ini import edemez.
- Domain, Flutter ve platform paketlerini import edemez.
- Feature'lar başka feature'ın data veya presentation katmanını import edemez.
- Platform implementasyonları portların adapter'ıdır.
- Yalnız gerçek bir platform/depolama/test sınırı bulunan yerde soyutlama oluşturulur.

