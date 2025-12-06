@echo off
setlocal enabledelayedexpansion

REM Dieses Skript baut ein Release-App-Bundle für den Play Store.
REM Aufruf: tools\build_play_release.bat [-clean]

cd /d "%~dp0\.."
echo === QuantumResonanz: Play-Store-Release-Build ===

REM Optional: flutter clean
if /I "%1"=="-clean" (
  echo flutter clean ...
  flutter clean
)

echo flutter pub get ...
flutter pub get

echo flutter build appbundle --release ...
flutter build appbundle --release

echo.
echo Fertig. Das App-Bundle findest du hier:
echo   build\app\outputs\bundle\release\app-release.aab
echo Dieses .aab kannst du in der Google Play Console im Produktions-Release hochladen.

endlocal


