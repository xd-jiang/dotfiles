#!/bin/bash

set -e

echo "🚀 Installing fnm (Fast Node Manager)..."

# Install fnm
if command -v fnm &> /dev/null; then
    echo "✓ fnm is already installed"
else
    curl -fsSL https://fnm.vercel.app/install | bash
    echo "✓ fnm installed successfully"
fi

# Load fnm into current shell
export PATH="$HOME/.local/share/fnm:$PATH"
eval "$(fnm env --use-on-cd)"

echo ""
echo "📦 Installing latest stable Node.js version..."

# Install latest LTS Node.js
fnm install --lts
fnm use lts-latest
fnm default lts-latest

echo "✓ Node.js $(node --version) installed"
echo "✓ npm $(npm --version) installed"

echo ""
echo "📦 Installing global npm packages..."

# Install global packages
npm install -g pnpm taze yarn tsx vitest

echo ""
echo "✅ Installation complete!"
echo ""
echo "Installed packages:"
echo "  - pnpm: $(pnpm --version)"
echo "  - taze: $(taze --version 2>/dev/null || echo 'installed')"
echo "  - yarn: $(yarn --version)"
echo "  - tsx: $(tsx --version)"
echo "  - vitest: $(vitest --version)"
echo ""
echo "💡 To use fnm in new shell sessions, add this to your ~/.zshrc:"
echo '   eval "$(fnm env --use-on-cd)"'
