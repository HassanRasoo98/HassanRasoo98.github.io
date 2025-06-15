#!/bin/bash

# 🚀 Super simple Cursor setup for Linux
set -e

APP_NAME="cursor"
INSTALL_DIR="$HOME/.local/bin/$APP_NAME"
DESKTOP_FILE="$HOME/.local/share/applications/$APP_NAME.desktop"
APPIMAGE_PATH="$HOME/Downloads/Cursor-*.AppImage"

echo "✨ Installing Cursor..."

# Make sure the AppImage exists
APPIMAGE_FILE=$(ls $APPIMAGE_PATH 2>/dev/null | head -n 1)
if [ ! -f "$APPIMAGE_FILE" ]; then
  echo "❌ Could not find Cursor AppImage at $APPIMAGE_PATH"
  echo "📦 Download it from: https://www.cursor.so/download"
  exit 1
fi

# Extract AppImage
chmod +x "$APPIMAGE_FILE"
mkdir -p "$INSTALL_DIR"
"$APPIMAGE_FILE" --appimage-extract
mv squashfs-root/* "$INSTALL_DIR"

# Fix chrome-sandbox permissions
if [ -f "$INSTALL_DIR/chrome-sandbox" ]; then
  echo "🔐 Fixing sandbox..."
  sudo chown root:root "$INSTALL_DIR/chrome-sandbox"
  sudo chmod 4755 "$INSTALL_DIR/chrome-sandbox"
fi

# Find a good icon
ICON_PATH="$INSTALL_DIR/cursor.png"
ICON_CANDIDATES=(
  "$INSTALL_DIR/usr/share/icons/hicolor/512x512/apps/cursor.png"
  "$INSTALL_DIR/resources/app/assets/icon.png"
)
for icon in "${ICON_CANDIDATES[@]}"; do
  if [ -f "$icon" ]; then
    cp "$icon" "$ICON_PATH"
    break
  fi
done

# Create .desktop launcher
mkdir -p "$(dirname "$DESKTOP_FILE")"
cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=Cursor
Exec=$INSTALL_DIR/AppRun
Icon=$ICON_PATH
Type=Application
Categories=Development;IDE;
StartupNotify=true
EOF

update-desktop-database ~/.local/share/applications

echo "✅ Done! You can now launch Cursor from your app menu or by running:"
echo "$INSTALL_DIR/AppRun"