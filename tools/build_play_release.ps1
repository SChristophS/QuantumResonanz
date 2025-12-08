Param(
  [switch]$Clean
)

$ErrorActionPreference = 'Stop'

# In Flutter-Projekt wechseln (dieses Skript liegt in tools/)
$repoRoot = Join-Path $PSScriptRoot '..'
# Das Flutter-Projekt liegt direkt im Repo-Root
$flutterRoot = $repoRoot
Set-Location -Path $flutterRoot

Write-Host "=== QuantumResonanz: Play-Store-Release-Build ===" -ForegroundColor Cyan

# 1) Keystore aus Base64 erzeugen oder neu erstellen (falls noch nicht vorhanden)
$base64Path = "keystore.jks.base64"
$keystorePath = "android/app/upload-keystore.jks"

if (Test-Path $keystorePath) {
    Write-Host "Keystore $keystorePath existiert bereits." -ForegroundColor Green
} elseif (Test-Path $base64Path) {
    Write-Host "Keystore fehlt, erstelle $keystorePath aus $base64Path ..." -ForegroundColor Yellow
    $b64 = Get-Content $base64Path -Raw
    $bytes = [Convert]::FromBase64String($b64)
    $keystoreDir = Split-Path $keystorePath -Parent
    if (-not (Test-Path $keystoreDir)) {
        New-Item -ItemType Directory -Path $keystoreDir -Force | Out-Null
    }
    [IO.File]::WriteAllBytes($keystorePath, $bytes)
    Write-Host "Keystore geschrieben." -ForegroundColor Green
} else {
    Write-Host "Keystore nicht gefunden. Erstelle neuen Release-Keystore..." -ForegroundColor Yellow
    $keytoolPath = $null
    
    # Try to find keytool
    if ($env:JAVA_HOME) {
        $keytoolPath = Join-Path $env:JAVA_HOME "bin\keytool.exe"
    }
    
    if (-not $keytoolPath -or -not (Test-Path $keytoolPath)) {
        $javaCmd = Get-Command java -ErrorAction SilentlyContinue
        if ($javaCmd) {
            $javaPath = $javaCmd.Source
            $jdkPath = Split-Path (Split-Path $javaPath -Parent) -Parent
            $keytoolPath = Join-Path $jdkPath "bin\keytool.exe"
        }
    }
    
    if ($keytoolPath -and (Test-Path $keytoolPath)) {
        Write-Host "Erstelle Keystore mit keytool..." -ForegroundColor Cyan
        $keystoreDir = Split-Path $keystorePath -Parent
        if (-not (Test-Path $keystoreDir)) {
            New-Item -ItemType Directory -Path $keystoreDir -Force | Out-Null
        }
        
        $keyProps = @{}
        $keyPropsPath = "android/key.properties"
        if (Test-Path $keyPropsPath) {
            Get-Content $keyPropsPath | Where-Object { $_ -match '=' } | ForEach-Object {
                $parts = $_ -split '=', 2
                if ($parts.Length -eq 2) {
                    $keyProps[$parts[0].Trim()] = $parts[1].Trim()
                }
            }
        }
        
        $storePass = if ($keyProps.ContainsKey('storePassword')) { $keyProps['storePassword'] } else { 'waseingeilespasswort1337!' }
        $keyPass = if ($keyProps.ContainsKey('keyPassword')) { $keyProps['keyPassword'] } else { 'waseingeilespasswort1337!' }
        $alias = if ($keyProps.ContainsKey('keyAlias')) { $keyProps['keyAlias'] } else { 'upload' }
        
        $dname = "CN=QuantumResonanz, OU=Development, O=QuantumResonanz, L=City, ST=State, C=US"
        & $keytoolPath -genkey -v -keystore $keystorePath -keyalg RSA -keysize 2048 -validity 10000 -alias $alias -storepass $storePass -keypass $keyPass -dname $dname -noprompt
        
        if (Test-Path $keystorePath) {
            Write-Host "Keystore erfolgreich erstellt!" -ForegroundColor Green
        } else {
            Write-Host "FEHLER: Keystore konnte nicht erstellt werden!" -ForegroundColor Red
            Write-Host "Bitte erstelle den Keystore manuell mit:" -ForegroundColor Yellow
            Write-Host "keytool -genkey -v -keystore $keystorePath -keyalg RSA -keysize 2048 -validity 10000 -alias $alias -storepass $storePass -keypass $keyPass" -ForegroundColor Yellow
            throw "Keystore creation failed"
        }
    } else {
        Write-Host "FEHLER: keytool nicht gefunden!" -ForegroundColor Red
        Write-Host "Bitte installiere JDK oder erstelle den Keystore manuell." -ForegroundColor Yellow
        Write-Host "Der Keystore MUSS existieren, damit ein Release-Build erstellt werden kann." -ForegroundColor Red
        throw "Keystore not found and keytool not available"
    }
}

# 2) Optional clean
if ($Clean) {
    Write-Host "flutter clean ..." -ForegroundColor Yellow
    flutter clean
    if ($LASTEXITCODE -ne 0) {
        throw "flutter clean failed"
    }
}

Write-Host "flutter pub get ..." -ForegroundColor Yellow
flutter pub get
if ($LASTEXITCODE -ne 0) {
    throw "flutter pub get failed"
}

# 3) Release-Build als App Bundle (für Play Store empfohlen) mit Obfuscation
Write-Host "Creating debug info directory..." -ForegroundColor Yellow
$debugInfoDir = Join-Path $repoRoot "build/debug-info"
if (-not (Test-Path $debugInfoDir)) {
    New-Item -Path $debugInfoDir -ItemType Directory -Force | Out-Null
}

Write-Host "flutter build appbundle --release --obfuscate --split-debug-info=$debugInfoDir ..." -ForegroundColor Yellow
flutter build appbundle --release --obfuscate --split-debug-info=$debugInfoDir

if ($LASTEXITCODE -ne 0) {
    throw "App bundle build failed with exit code $LASTEXITCODE"
}

$bundlePath = "build/app/outputs/bundle/release/app-release.aab"
if (Test-Path $bundlePath) {
    $file = Get-Item $bundlePath
    Write-Host ""
    Write-Host "Fertig. Das App-Bundle findest du hier:" -ForegroundColor Green
    Write-Host "  $($file.FullName)" -ForegroundColor Green
    Write-Host "  Groesse: $([math]::Round($file.Length / 1MB, 2)) MB" -ForegroundColor Green
    Write-Host "Dieses .aab kannst du im Play Console Upload verwenden." -ForegroundColor Cyan
} else {
    Write-Host ""
    Write-Host "FEHLER: Bundle nicht gefunden unter: $bundlePath" -ForegroundColor Red
    throw "Bundle file not found after build"
}
