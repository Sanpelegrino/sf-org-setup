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
    goto :done
)

:: Check for Salesforce CLI
where sf >nul 2>&1
if %errorlevel% neq 0 (
    echo  Salesforce CLI [sf] is not installed.
    echo.
    set /p INSTALL_SF="  Install it now via winget? (Y/N): "
    if /i not "%INSTALL_SF%"=="Y" (
        echo.
        echo  Cannot continue without Salesforce CLI.
        echo  Install manually: https://developer.salesforce.com/tools/salesforcecli
        goto :done
    )
    echo.
    echo  Installing Salesforce CLI...
    winget install Salesforce.CLI --accept-source-agreements --accept-package-agreements
    if %errorlevel% neq 0 (
        echo.
        echo  ERROR: Install failed. Try manually: https://developer.salesforce.com/tools/salesforcecli
        goto :done
    )
    echo.
    echo  Installed successfully.
    echo  Please close this window and double-click Setup.bat again.
    goto :done
)

echo  Found: PowerShell, Salesforce CLI
echo.

:: Run the setup script
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\salesforce\org-setup\run-setup.ps1"

:done
echo.
echo  ============================================
echo   Press any key to close this window.
echo  ============================================
pause >nul
