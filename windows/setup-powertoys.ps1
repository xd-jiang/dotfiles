# PowerShell script to configure PowerToys Keyboard Manager
# Run this after installing PowerToys from: https://github.com/microsoft/PowerToys/releases

Write-Host "=================================="
Write-Host "PowerToys Keyboard Manager Setup"
Write-Host "=================================="
Write-Host ""

# Check if PowerToys is installed
$powerToysPath = "$env:LOCALAPPDATA\Microsoft\PowerToys"
if (-Not (Test-Path $powerToysPath)) {
    Write-Host "❌ PowerToys not found!"
    Write-Host ""
    Write-Host "Please install PowerToys first:"
    Write-Host "  Download: https://github.com/microsoft/PowerToys/releases"
    Write-Host "  Or use: winget install Microsoft.PowerToys"
    exit 1
}

Write-Host "✓ PowerToys found at: $powerToysPath"
Write-Host ""

# Configuration path
$kbmConfigDir = "$powerToysPath\Keyboard Manager"
$kbmConfigFile = "$kbmConfigDir\default.json"

# Create directory if not exists
if (-Not (Test-Path $kbmConfigDir)) {
    New-Item -ItemType Directory -Path $kbmConfigDir -Force | Out-Null
}

# Keyboard Manager configuration (swap Left Ctrl <-> Left Alt, CapsLock -> Escape)
$config = @"
{
  "remapKeys": {
    "inProcess": [
      {
        "originalKeys": "162",
        "newRemapKeys": "164"
      },
      {
        "originalKeys": "164",
        "newRemapKeys": "162"
      },
      {
        "originalKeys": "20",
        "newRemapKeys": "27"
      }
    ]
  },
  "remapShortcuts": {
    "global": [],
    "appSpecific": []
  }
}
"@

# Write configuration
$config | Out-File -FilePath $kbmConfigFile -Encoding UTF8 -Force

Write-Host "✓ Configuration written to: $kbmConfigFile"
Write-Host ""
Write-Host "Key mappings configured:"
Write-Host "  • Left Ctrl ↔ Left Alt (swapped)"
Write-Host "  • CapsLock → Escape"
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Open PowerToys"
Write-Host "  2. Go to Keyboard Manager"
Write-Host "  3. Enable 'Remap keys'"
Write-Host "  4. Restart your computer for changes to take effect"
Write-Host ""
