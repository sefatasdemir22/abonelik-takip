$flutterRoot = 'C:\tools\flutter'
$jdkRoot = 'C:\tools\jdk-17'
$androidRoot = 'C:\Users\sefat\AppData\Local\Android\Sdk'

foreach ($requiredPath in $flutterRoot, $jdkRoot, $androidRoot) {
    if (-not (Test-Path -LiteralPath $requiredPath -PathType Container)) {
        throw "Gerekli araç dizini bulunamadı: $requiredPath"
    }
}

$env:FLUTTER_ROOT = $flutterRoot
$env:JAVA_HOME = $jdkRoot
$env:ANDROID_SDK_ROOT = $androidRoot
$env:PATH = "$flutterRoot\bin;$jdkRoot\bin;$androidRoot\platform-tools;$androidRoot\cmdline-tools\latest\bin;$env:PATH"

Write-Host 'Project tooling configured:'
Write-Host "  Flutter: $flutterRoot"
Write-Host "  Java:    $jdkRoot"
Write-Host "  Android: $androidRoot"
Write-Host "  Pub:     $env:LOCALAPPDATA\Pub\Cache (default)"
