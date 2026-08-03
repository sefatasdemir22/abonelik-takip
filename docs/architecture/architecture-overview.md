# Mimari görünüm

Uygulama Android-first ve local-first çalışır. Flutter UI ile platformdan bağımsız saf Dart domain kuralları birbirinden ayrılır. Drift yerel ana veri kaynağıdır; Android bildirimleri domain portunun adapter'ı olarak bağlanır.

```mermaid
flowchart LR
    APP["Composition root"] --> UI["Feature presentation"]
    UI --> DOMAIN["Saf Dart domain"]
    DATA["Drift repository adapter"] --> DOMAIN
    NOTIFICATIONS["Android notification adapter"] --> DOMAIN
    APP --> DATA
    APP --> NOTIFICATIONS
```

İlk dikey dilim yalnız aylık düzenli ödeme, vade occurrence'ı, paid/skipped sonucu ve takvim ayı özetini kapsar.

