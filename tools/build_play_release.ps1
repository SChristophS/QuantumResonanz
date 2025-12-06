Param(
  [switch]$Clean
)

$ErrorActionPreference = 'Stop'

# In Flutter-Projekt wechseln (dieses Skript liegt in tools/)
# In Flutter-Projekt wechseln (dieses Skript liegt in tools/)
$repoRoot = Join-Path $PSScriptRoot '..'
# Das Flutter-Projekt liegt direkt im Repo-Root
$flutterRoot = $repoRoot
Set-Location -Path $flutterRoot

Write-Host "=== QuantumResonanz: Play-Store-Release-Build ==="
Write-Host "=== QuantumResonanz: Play-Store-Release-Build ==="

# 1) Keystore aus Base64 erzeugen (falls noch nicht vorhanden)
$base64Path = "keystore.jks.base64"
$keystorePath = "android/app/upload-keystore.jks"

if (Test-Path $base64Path) {
  if (-not (Test-Path $keystorePath)) {
    Write-Host "Keystore fehlt, erstelle $keystorePath aus $base64Path ..."
    $b64 = Get-Content $base64Path -Raw
    $bytes = [Convert]::FromBase64String($b64)
    [IO.File]::WriteAllBytes($keystorePath, $bytes)
    Write-Host "Keystore geschrieben."
  } else {
    Write-Host "Keystore $keystorePath existiert bereits – überspringe Decode-Schritt."
  }
} else {
  Write-Host "Hinweis: $base64Path nicht gefunden – gehe davon aus, dass $keystorePath bereits existiert und korrekt konfiguriert ist."
}

# 2) Optional clean
if ($Clean) {
  Write-Host "flutter clean ..."
  flutter clean
}

Write-Host "flutter pub get ..."
flutter pub get

# 3) Release-Build als App Bundle (für Play Store empfohlen) mit Obfuscation
Write-Host "Creating debug info directory..."
$debugInfoDir = Join-Path $repoRoot "build/debug-info"
if (-not (Test-Path $debugInfoDir)) {
    New-Item -Path $debugInfoDir -ItemType Directory -Force | Out-Null
}

Write-Host "flutter build appbundle --release --obfuscate --split-debug-info=$debugInfoDir ..."
flutter build appbundle --release --obfuscate --split-debug-info=$debugInfoDir

Write-Host ""
Write-Host "Fertig. Das App-Bundle findest du hier:"
Write-Host "  build/app/outputs/bundle/release/app-release.aab"
Write-Host "Dieses .aab kannst du im Play Console Upload verwenden."

