Param(
    [switch]$Clean,
    [switch]$SkipChecks,
    [switch]$SkipVersionBump,
    [ValidateSet('apk-debug', 'apk-release', 'apk-split', 'bundle-release', 'bundle-test', '')]
    [string]$Mode = ''
)

$ErrorActionPreference = 'Stop'

# Always work relative to repo root / Flutter-Projekt
$repoRoot = Join-Path $PSScriptRoot '..'
# In diesem Projekt liegt das Flutter-Projekt direkt im Repo-Root
$flutterRoot = $repoRoot
Set-Location -Path $flutterRoot

# Colors for output
function Write-Info { param([string]$msg) Write-Host "INFO: $msg" -ForegroundColor Cyan }
function Write-Success { param([string]$msg) Write-Host "OK: $msg" -ForegroundColor Green }
function Write-Warning { param([string]$msg) Write-Host "WARNING: $msg" -ForegroundColor Yellow }
function Write-Error { param([string]$msg) Write-Host "ERROR: $msg" -ForegroundColor Red }

# Get version info from pubspec.yaml
function Get-VersionInfo {
    $versionLine = Select-String -Path 'pubspec.yaml' -Pattern '^\s*version:\s*(.+)$' | Select-Object -First 1
    if (-not $versionLine) {
        throw 'Could not find version: entry in pubspec.yaml'
    }

    $value = $versionLine.Matches[0].Groups[1].Value.Trim()
    $parts = $value -split '\+'
    $name = $parts[0]
    $build = if ($parts.Length -gt 1) { [int]$parts[1] } else { 0 }
    
    return @{
        Full  = $value
        Name  = $name
        Build = $build
        Line  = $versionLine
    }
}

# Increment build number and save to pubspec.yaml
function Increment-BuildNumber {
    param(
        [hashtable]$VersionInfo
    )
    
    $newBuild = $VersionInfo.Build + 1
    $newVersion = "$($VersionInfo.Name)+$newBuild"
    
    Write-Info "Incrementing build number: $($VersionInfo.Build) -> $newBuild"
    
    $pubspec = Get-Content 'pubspec.yaml' -Raw
    $oldLine = $VersionInfo.Line.Line.TrimEnd()
    $newLine = "version: $newVersion"
    
    if ($pubspec -match [regex]::Escape($oldLine)) {
        $pubspec = $pubspec -replace [regex]::Escape($oldLine), $newLine
        Set-Content -Path 'pubspec.yaml' -Value $pubspec -NoNewline
        Write-Success "Updated pubspec.yaml: $newVersion"
    } else {
        throw "Could not update version line in pubspec.yaml"
    }
    
    return @{
        Full  = $newVersion
        Name  = $VersionInfo.Name
        Build = $newBuild
    }
}

# Pre-flight checks
function Invoke-PreFlightChecks {
    Write-Host ""
    Write-Host "=== Pre-flight Checks ===" -ForegroundColor Cyan
    
    # Check Flutter installation
    Write-Info "Checking Flutter installation..."
    $flutterVersion = flutter --version 2>&1 | Select-String -Pattern 'Flutter (\d+\.\d+\.\d+)' | ForEach-Object { $_.Matches[0].Groups[1].Value }
    if (-not $flutterVersion) {
        throw "Flutter is not installed or not in PATH"
    }
    Write-Success "Flutter $flutterVersion found"
    
    # Check pubspec.yaml
    Write-Info "Validating pubspec.yaml..."
    if (-not (Test-Path 'pubspec.yaml')) {
        throw "pubspec.yaml not found in project root"
    }
    $versionInfo = Get-VersionInfo
    Write-Success "Version: $($versionInfo.Name) (build $($versionInfo.Build))"
    
    # Run flutter analyze
    Write-Info "Running flutter analyze..."
    $analyzeResult = flutter analyze 2>&1 | Out-String
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "flutter analyze found issues:"
        Write-Host $analyzeResult
        $continue = Read-Host "Continue anyway? (y/N)"
        if ($continue -ne 'y' -and $continue -ne 'Y') {
            throw "Build cancelled due to analyze issues"
        }
    } else {
        Write-Success "flutter analyze passed"
    }
    
    # Optional: Run tests (can be slow)
    Write-Info "Do you want to run tests? (y/N)"
    $runTests = Read-Host
    if ($runTests -eq 'y' -or $runTests -eq 'Y') {
        Write-Info "Running flutter test..."
        flutter test
        if ($LASTEXITCODE -ne 0) {
            Write-Warning "Tests failed!"
            $continue = Read-Host "Continue anyway? (y/N)"
            if ($continue -ne 'y' -and $continue -ne 'Y') {
                throw "Build cancelled due to test failures"
            }
        } else {
            Write-Success "All tests passed"
        }
    }
    
    Write-Host ""
    Write-Success "Pre-flight checks completed"
    return $versionInfo
}

# Ensure exports directory exists
function Ensure-ExportsDir {
    $exports = Join-Path $repoRoot 'build/exports'
    if (-not (Test-Path $exports)) {
        New-Item -Path $exports -ItemType Directory -Force | Out-Null
    }
    return $exports
}

# Ensure keystore exists for signed builds
function Ensure-Keystore {
    # 1) Prüfe zuerst, ob ein Keystore über android/key.properties referenziert wird.
    $keyPropsPath = 'android/key.properties'
    if (Test-Path $keyPropsPath) {
        $props = Get-Content $keyPropsPath | Where-Object { $_ -match '=' }
        $dict = @{}
        foreach ($line in $props) {
            $parts = $line -split '=', 2
            if ($parts.Length -eq 2) {
                $k = $parts[0].Trim()
                $v = $parts[1].Trim()
                if ($k) { $dict[$k] = $v }
            }
        }

        if ($dict.ContainsKey('storeFile')) {
            $sf = $dict['storeFile']
            # Wenn nur Dateiname, relativ zu android/app interpretieren
            $resolved = if ($sf -match '[:\\/]' ) {
                $sf
            } else {
                Join-Path 'android/app' $sf
            }

            if (Test-Path $resolved) {
                Write-Success "Keystore found via android/key.properties: $resolved"
                return
            } else {
                Write-Warning "Keystore path from android/key.properties not found: $resolved"
            }
        }
    }

    # 2) Fallback: altes Verhalten mit lokaler Base64-Datei im Repo
    $base64Path = 'keystore.jks.base64'
    $keystorePath = 'android/app/upload-keystore.jks'
    
    if (-not (Test-Path $keystorePath)) {
        if (Test-Path $base64Path) {
            Write-Info "Decoding keystore from base64..."
            $b64 = Get-Content $base64Path -Raw
            $bytes = [Convert]::FromBase64String($b64)
            $keystoreDir = Split-Path $keystorePath -Parent
            if (-not (Test-Path $keystoreDir)) {
                New-Item -ItemType Directory -Path $keystoreDir -Force | Out-Null
            }
            [IO.File]::WriteAllBytes($keystorePath, $bytes)
            Write-Success "Keystore decoded: $keystorePath"
        } else {
            Write-Warning "Keystore not found: $keystorePath"
            Write-Warning "Make sure you have a valid keystore for signed builds"
        }
    }
}

# Build functions
function Build-ApkDebug {
    param([hashtable]$VersionInfo)
    
    Write-Host ""
    Write-Host "=== Building Debug APK ===" -ForegroundColor Cyan
    flutter build apk --debug
    
    if ($LASTEXITCODE -ne 0) {
        throw "APK debug build failed"
    }
    
    $src = 'build/app/outputs/flutter-apk/app-debug.apk'
    if (-not (Test-Path $src)) {
        throw "APK not found: $src"
    }
    
    $destDir = Ensure-ExportsDir
    $dest = Join-Path $destDir "QuantumResonanz-debug-$($VersionInfo.Name)-build$($VersionInfo.Build).apk"
    Copy-Item $src $dest -Force
    Write-Success "Debug APK: $dest"
    return $dest
}

function Build-ApkRelease {
    param([hashtable]$VersionInfo)
    
    Write-Host ""
    Write-Host "=== Building Release APK ===" -ForegroundColor Cyan
    Ensure-Keystore
    flutter build apk --release
    
    if ($LASTEXITCODE -ne 0) {
        throw "APK release build failed"
    }
    
    $src = 'build/app/outputs/flutter-apk/app-release.apk'
    if (-not (Test-Path $src)) {
        throw "APK not found: $src"
    }
    
    $destDir = Ensure-ExportsDir
    $dest = Join-Path $destDir "QuantumResonanz-release-$($VersionInfo.Name)-build$($VersionInfo.Build).apk"
    Copy-Item $src $dest -Force
    Write-Success "Release APK: $dest"
    return $dest
}

function Build-ApkSplit {
    param([hashtable]$VersionInfo)
    
    Write-Host ""
    Write-Host "=== Building Split APKs (per ABI) ===" -ForegroundColor Cyan
    Ensure-Keystore
    flutter build apk --release --split-per-abi
    
    if ($LASTEXITCODE -ne 0) {
        throw "Split APK build failed"
    }
    
    $srcDir = 'build/app/outputs/flutter-apk'
    $destDir = Ensure-ExportsDir
    $apkFiles = Get-ChildItem -Path $srcDir -Filter 'app-*-release.apk'
    
    Write-Host ""
    Write-Success "Split APKs created:"
    foreach ($apk in $apkFiles) {
        $abiName = $apk.Name -replace 'app-(.+)-release\.apk', '$1'
        $dest = Join-Path $destDir "QuantumResonanz-split-$abiName-$($VersionInfo.Name)-build$($VersionInfo.Build).apk"
        Copy-Item $apk.FullName $dest -Force
        Write-Success "  $abiName`: $dest"
    }
}

function Build-AppBundle {
    param(
        [hashtable]$VersionInfo,
        [string]$VariantLabel
    )
    
    Write-Host ""
    Write-Host "=== Building App Bundle ($VariantLabel) ===" -ForegroundColor Cyan
    Ensure-Keystore
    flutter build appbundle --release
    
    if ($LASTEXITCODE -ne 0) {
        throw "App bundle build failed"
    }
    
    $src = 'build/app/outputs/bundle/release/app-release.aab'
    if (-not (Test-Path $src)) {
        throw "Bundle not found: $src"
    }
    
    $destDir = Ensure-ExportsDir
    $dest = Join-Path $destDir "QuantumResonanz-$VariantLabel-$($VersionInfo.Name)-build$($VersionInfo.Build).aab"
    Copy-Item $src $dest -Force
    Write-Success "App Bundle: $dest"
    return $dest
}

# Main script
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  QuantumResonanz - Build Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Get initial version info
$versionInfo = Get-VersionInfo
Write-Host "Current version: $($versionInfo.Name) (build $($versionInfo.Build))" -ForegroundColor White
Write-Host ""

# Pre-flight checks
if (-not $SkipChecks) {
    $versionInfo = Invoke-PreFlightChecks
} else {
    Write-Warning "Skipping pre-flight checks (--SkipChecks)"
}

# Clean if requested
if ($Clean) {
    Write-Host ""
    Write-Info "Running flutter clean..."
    flutter clean
    Write-Success "Clean completed"
}

# Pub get
Write-Host ""
Write-Info "Running flutter pub get..."
flutter pub get
if ($LASTEXITCODE -ne 0) {
    throw "flutter pub get failed"
}
Write-Success "Dependencies resolved"

# Version bump (before build)
if (-not $SkipVersionBump) {
    Write-Host ""
    $bump = Read-Host "Increment build number before building? (Y/n)"
    if ($bump -ne 'n' -and $bump -ne 'N') {
        $versionInfo = Increment-BuildNumber -VersionInfo $versionInfo
        Write-Host "Building with version: $($versionInfo.Name) (build $($versionInfo.Build))" -ForegroundColor White
    }
} else {
    Write-Warning "Skipping version bump (--SkipVersionBump)"
}

# Select build mode
if (-not $Mode) {
    Write-Host ""
    Write-Host "Select build type:" -ForegroundColor Cyan
    Write-Host "  [1] Debug APK (for local testing)"
    Write-Host "  [2] Release APK (signed, single file)"
    Write-Host "  [3] Split APKs (per ABI, smaller files)"
    Write-Host "  [4] App Bundle - Test (for internal/closed track)"
    Write-Host "  [5] App Bundle - Release (for production)"
    Write-Host ""
    $choice = Read-Host "Enter 1-5"
    
    switch ($choice) {
        '1' { $Mode = 'apk-debug' }
        '2' { $Mode = 'apk-release' }
        '3' { $Mode = 'apk-split' }
        '4' { $Mode = 'bundle-test' }
        '5' { $Mode = 'bundle-release' }
        default { throw "Invalid choice: $choice" }
    }
}

# Execute build
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Starting Build" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

switch ($Mode) {
    'apk-debug' {
        Build-ApkDebug -VersionInfo $versionInfo
    }
    'apk-release' {
        Build-ApkRelease -VersionInfo $versionInfo
    }
    'apk-split' {
        Build-ApkSplit -VersionInfo $versionInfo
    }
    'bundle-test' {
        Build-AppBundle -VersionInfo $versionInfo -VariantLabel 'playtest'
    }
    'bundle-release' {
        Build-AppBundle -VersionInfo $versionInfo -VariantLabel 'playrelease'
    }
    default {
        throw "Unknown build mode: $Mode"
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Success "Build completed successfully!"
Write-Host "All builds saved to: build/exports/" -ForegroundColor White
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
