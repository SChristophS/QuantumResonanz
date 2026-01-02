$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

Write-Host "Starting bundle build with obfuscation..." -ForegroundColor Cyan

# Ensure debug-info directory exists
$debugInfoDir = Join-Path $PSScriptRoot "build\debug-info"
if (-not (Test-Path $debugInfoDir)) {
    New-Item -Path $debugInfoDir -ItemType Directory -Force | Out-Null
    Write-Host "Created debug-info directory" -ForegroundColor Green
}

# Run flutter pub get first
Write-Host "Running flutter pub get..." -ForegroundColor Yellow
flutter pub get
if ($LASTEXITCODE -ne 0) {
    Write-Host "flutter pub get failed!" -ForegroundColor Red
    exit 1
}

# Run the build
Write-Host "Building app bundle with obfuscation..." -ForegroundColor Yellow
flutter build appbundle --release --obfuscate --split-debug-info=build/debug-info

$exitCode = $LASTEXITCODE
$bundlePath = "build\app\outputs\bundle\release\app-release.aab"

if ($exitCode -eq 0) {
    if (Test-Path $bundlePath) {
        $file = Get-Item $bundlePath
        Write-Host "`nBuild SUCCESSFUL!" -ForegroundColor Green
        Write-Host "Bundle location: $($file.FullName)" -ForegroundColor Green
        Write-Host "Size: $([math]::Round($file.Length / 1MB, 2)) MB" -ForegroundColor Green
        Write-Host "Last modified: $($file.LastWriteTime)" -ForegroundColor Green
    } else {
        Write-Host "`nBuild completed but bundle not found at: $bundlePath" -ForegroundColor Yellow
        Write-Host "Exit code was: $exitCode" -ForegroundColor Yellow
    }
} else {
    Write-Host "`nBuild FAILED with exit code: $exitCode" -ForegroundColor Red
}

exit $exitCode



