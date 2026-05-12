@echo off
title Salesforce Org Setup - Tableau Next
echo.
echo  ============================================
echo   Salesforce Org Setup for Tableau Next
echo  ============================================
echo.

:: Check for PowerShell
where powershell >nul 2>&1
if %errorlevel% neq 0 (
    echo  ERROR: PowerShell is not installed.
    echo  This should not happen on Windows 10/11.
    pause
    exit /b 1
)

:: Check for Salesforce CLI
where sf >nul 2>&1
if %errorlevel% neq 0 (
    echo  Salesforce CLI (sf) is not installed.
    echo.
    choice /C YN /M "  Install it now via winget?"
    if errorlevel 2 (
        echo.
        echo  Cannot continue without Salesforce CLI.
        echo  Install manually: https://developer.salesforce.com/tools/salesforcecli
        pause
        exit /b 1
    )
    echo.
    echo  Installing Salesforce CLI...
    winget install Salesforce.CLI --accept-source-agreements --accept-package-agreements
    if %errorlevel% neq 0 (
        echo.
        echo  ERROR: Install failed. Try manually: https://developer.salesforce.com/tools/salesforcecli
        pause
        exit /b 1
    )
    echo.
    echo  Installed. You may need to close and reopen this window for "sf" to be on PATH.
    echo  Re-run Setup.bat after reopening.
    pause
    exit /b 0
)

:: Run the setup script
powershell -ExecutionPolicy Bypass -File "%~dp0scripts\salesforce\org-setup\run-setup.ps1"
echo.
pause
