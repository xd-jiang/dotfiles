# Windows Setup

## Key Mapping with PowerToys

Windows uses PowerToys Keyboard Manager for key remapping.

### Installation

```bash
# Using winget (Windows 10 1709+)
winget install Microsoft.PowerToys

# Or download from GitHub
# https://github.com/microsoft/PowerToys/releases
```

### Configuration

After installing PowerToys, run the setup script:

```powershell
powershell -ExecutionPolicy Bypass -File setup-powertoys.ps1
```

Or manually configure in PowerToys:
1. Open PowerToys
2. Go to **Keyboard Manager**
3. Click **Remap a key**
4. Add these mappings:
   - Left Ctrl → Left Alt
   - Left Alt → Left Ctrl  
   - Caps Lock → Esc

### File Limits

Windows doesn't have the same file descriptor limits as Linux/macOS. If you encounter issues with file watchers in Node.js:

1. Increase Visual Studio Code's file watcher limit in `settings.json`:
   ```json
   "files.watcherExclude": {
     "**/node_modules/**": true,
     "**/.git/objects/**": true
   }
   ```

2. Use WSL2 for better Node.js performance with large projects.
