#!/bin/bash
# Double-click this file on macOS to run Salesforce Org Setup.
# It will open in Terminal automatically.

cd "$(dirname "$0")"

echo ""
echo "  ============================================"
echo "   Salesforce Org Setup for Tableau Next"
echo "  ============================================"
echo ""

# Check for Homebrew
if ! command -v brew &> /dev/null; then
    echo "  Homebrew is not installed. It's needed to install dependencies."
    echo ""
    read -p "  Install Homebrew now? (y/N) " ans
    if [[ "$ans" =~ ^[Yy]$ ]]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null
        eval "$(/usr/local/bin/brew shellenv)" 2>/dev/null
    else
        echo ""
        echo "  Cannot continue without Homebrew."
        echo "  Install manually: https://brew.sh"
        echo ""
        read -p "  Press Enter to close..."
        exit 1
    fi
fi

# Check for PowerShell
if ! command -v pwsh &> /dev/null; then
    echo "  PowerShell 7 is not installed."
    echo ""
    read -p "  Install it now via Homebrew? (y/N) " ans
    if [[ "$ans" =~ ^[Yy]$ ]]; then
        brew install powershell/tap/powershell
        if [ $? -ne 0 ]; then
            echo ""
            echo "  ERROR: Install failed."
            echo "  Try manually: brew install powershell/tap/powershell"
            read -p "  Press Enter to close..."
            exit 1
        fi
    else
        echo ""
        echo "  Cannot continue without PowerShell."
        read -p "  Press Enter to close..."
        exit 1
    fi
fi

# Check for Salesforce CLI
if ! command -v sf &> /dev/null; then
    echo "  Salesforce CLI (sf) is not installed."
    echo ""
    read -p "  Install it now via Homebrew? (y/N) " ans
    if [[ "$ans" =~ ^[Yy]$ ]]; then
        brew install sf
        if [ $? -ne 0 ]; then
            echo ""
            echo "  ERROR: Install failed."
            echo "  Try manually: https://developer.salesforce.com/tools/salesforcecli"
            read -p "  Press Enter to close..."
            exit 1
        fi
    else
        echo ""
        echo "  Cannot continue without Salesforce CLI."
        read -p "  Press Enter to close..."
        exit 1
    fi
fi

echo ""
pwsh ./scripts/salesforce/org-setup/run-setup.ps1
echo ""
read -p "  Press Enter to close..."
