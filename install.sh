#!/usr/bin/env bash
set -e

# ============================================================
# Dotfiles Installation Script
# Supports: macOS, Linux, Windows (Git Bash/WSL)
# ============================================================

# Load helper functions
. "$PWD/helper.sh"

# Detect OS
os_type=$(detect_os)
echo "=================================="
echo "Detected OS: $os_type"
echo "=================================="

user_home=$(get_user_home)
echo "User home: $user_home"
echo ""

# ============================================================
# 1. Fix system limits (for Node.js file watchers)
# ============================================================
echo ">>> Step 1: Checking system file limits..."

if [ "$os_type" = "linux" ]; then
    echo "Running fix_limits.sh for Linux..."
    bash "$PWD/fix_limits.sh"
elif [ "$os_type" = "mac" ]; then
    echo "Checking macOS file limits..."
    current_limit=$(ulimit -n)
    if [ "$current_limit" -lt 65535 ]; then
        echo "Setting file limit to 65535..."
        sudo launchctl limit maxfiles 65535 200000
        ulimit -n 65535
        echo "✓ File limit updated (may require restart)"
    else
        echo "✓ File limit already sufficient: $current_limit"
    fi
else
    echo "Windows detected - file limits not applicable"
fi

echo ""

# ============================================================
# 2. Install fnm and Node.js
# ============================================================
echo ">>> Step 2: Installing fnm and Node.js..."
bash "$PWD/fnm-node.sh"
echo ""

# ============================================================
# 3. Setup key mapping (Ctrl/Alt swap, CapsLock->Escape)
# ============================================================
echo ">>> Step 3: Setting up key mappings..."

case "$os_type" in
    mac)
        echo "macOS: Use Karabiner-Elements for key mapping"
        KEYMAP_SCRIPT="$PWD/mac/karabiner-keymap.sh"
        if [ -f "$KEYMAP_SCRIPT" ]; then
            bash "$KEYMAP_SCRIPT"
        else
            echo "⚠️  Karabiner script not found at $KEYMAP_SCRIPT"
            echo "Please install Karabiner-Elements manually:"
            echo "  brew install --cask karabiner-elements"
        fi
        ;;
    linux)
        echo "Linux: Using X11 keyboard configuration"
        KEYMAP_SCRIPT="$PWD/fix-keys.sh"
        if [ -f "$KEYMAP_SCRIPT" ]; then
            sudo bash "$KEYMAP_SCRIPT"
        else
            echo "⚠️  fix-keys.sh not found"
        fi
        ;;
    windows)
        echo "Windows: Please install PowerToys manually"
        echo "Download from: https://github.com/microsoft/PowerToys/releases"
        echo "Then configure Keyboard Manager to swap Ctrl/Alt"
        ;;
    *)
        echo "⚠️  Unsupported OS for key mapping"
        ;;
esac

echo ""

# ============================================================
# 4. Install and configure Zsh
# ============================================================
echo ">>> Step 4: Installing Zsh and Oh-My-Zsh..."
bash "$PWD/zsh.sh"
echo ""

# ============================================================
# 5. Configure VSCode
# ============================================================
echo ">>> Step 5: Configuring VSCode..."
bash "$PWD/vscode.sh"
echo ""

# ============================================================
# 6. Install Neovim configuration (optional)
# ============================================================
read -p ">>> Step 6: Install Neovim config? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [ -f "$PWD/nvim.sh" ]; then
        bash "$PWD/nvim.sh"
    else
        echo "⚠️  nvim.sh not found, skipping..."
    fi
fi

echo ""

# ============================================================
# Summary
# ============================================================
echo "=================================="
echo "✅ Installation Complete!"
echo "=================================="
echo ""
echo "What was installed:"
echo "  ✓ System file limits configured"
echo "  ✓ fnm + Node.js ($(node --version 2>/dev/null || echo 'pending'))"
echo "  ✓ Key mappings configured"
echo "  ✓ Zsh + Oh-My-Zsh + plugins"
echo "  ✓ VSCode settings linked"
echo ""
echo "Next steps:"
echo "  1. Restart your terminal (or run: source ~/.zshrc)"
echo "  2. For key mappings to take effect:"

case "$os_type" in
    mac)
        echo "     - Open Karabiner-Elements and import config"
        ;;
    linux)
        echo "     - Restart your X session or reboot"
        ;;
    windows)
        echo "     - Install PowerToys and configure Keyboard Manager"
        ;;
esac

echo ""
echo "  3. Verify Node.js: node --version"
echo "  4. Verify file limits: ulimit -n (should show 65535)"
echo ""
