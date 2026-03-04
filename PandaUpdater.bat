@echo off
rem encoding: utf-8
rem created by IndiePandaaaaa

echo "PANDA UPDATER"
echo "--- searching for updates ---"

echo "--- exclude apps which update on their own ---"
winget pin add Apple.AppleMobileDeviceSupport >nul 2>&1
winget pin add Apple.iTunes >nul 2>&1
winget pin add Discord.Discord >nul 2>&1
winget pin add EpicGames.EpicGamesLauncher >nul 2>&1
winget pin add Microsoft.VisualStudio.2022.Community >nul 2>&1
winget pin add Ubisoft.Connect >nul 2>&1
winget pin add Waterfox.Waterfox >nul 2>&1

echo "--- closing apps for updates ---"
taskkill /im "Ferdium.exe" /f >nul 2>&1
taskkill /im "obs32.exe" /f >nul 2>&1
taskkill /im "obs64.exe" /f >nul 2>&1
taskkill /im "python.exe" /f >nul 2>&1

echo "--- starting updates ---"
winget upgrade --source winget --all --include-unknown --accept-source-agreements --accept-package-agreements --silent

echo "UPDATES FINISHED"
pause
