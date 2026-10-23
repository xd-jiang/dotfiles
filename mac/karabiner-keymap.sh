#!/bin/sh

KAR_DIR="$HOME/.config/karabiner/assets/complex_modifications/"

# Create directory if it doesn't exist
mkdir -p "$KAR_DIR"

# Link karabiner config files
echo "Linking Karabiner configuration..."
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ln -sf "$SCRIPT_DIR/karabiner/"* "$KAR_DIR/"

echo "✓ Karabiner configuration linked to $KAR_DIR"
echo ""
echo "Please open Karabiner-Elements and enable the complex modifications."
