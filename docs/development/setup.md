# Geliştirme kurulumu

Kesin yerel klasör yapısı:

```text
C:\dev\abonelik-takip                         repository
C:\tools\flutter                             Flutter SDK
C:\tools\jdk-17                              Eclipse Temurin JDK 17
C:\Users\sefat\AppData\Local\Android\Sdk    Android SDK
C:\Users\sefat\AppData\Local\Pub\Cache      standart Pub cache
```

Sabitlenen araçlar:

- Flutter `3.44.8` / Dart `3.12.2`
- Eclipse Temurin JDK `17.0.20+8`
- Android min SDK `23`, compile SDK `36`
- Android build-tools `36.0.0`
- Android platform-tools `37.0.1`

Yeni PowerShell oturumunda:

```powershell
Set-Location C:\dev\abonelik-takip
Set-ExecutionPolicy -Scope Process Bypass
. .\tooling.ps1
Set-Location .\app
```

Doğrulama komutları:

```powershell
flutter --version
dart --version
flutter doctor -v
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
flutter build apk --debug
```

`Z:` sürücüsü, `subst`, proje içi Flutter/JDK kurulumu veya özel `PUB_CACHE` kullanılmaz. `tooling.ps1` Pub cache ortam değişkenini değiştirmez; Dart’ın standart Windows kullanıcı cache’i kullanılır.

Flutter uygulaması `app/` dizinindedir. CI aynı sürüm ve kalite kontrollerini temiz Linux ortamında çalıştırır.
