---
layout: post
title: "How to Install Cursor AppImage on Linux (Without FUSE)"
date: 2025-06-15
categories: [Linux, AppImage, Cursor]
---

> 📅 Updated: June 2025  
> ✍️ Author: Hassan Rasool  
> 📎 Use case: Run the AI-powered Cursor editor on Linux (Ubuntu, Debian, Arch, etc.) even though it’s not officially supported.

---

### 🚀 Overview

[Cursor](https://www.cursor.com/) is a powerful, AI-enhanced code editor based on VS Code. As of now, it doesn’t have official Linux support — only Windows and macOS binaries are available.

But if you’ve downloaded the Cursor AppImage, **you can still run it on Linux** by extracting it, fixing the Chrome sandbox permissions, and creating a `.desktop` file for launcher integration.

---

### ✅ What This Script Does

- Uses your already-downloaded `.AppImage` file
- Extracts the contents (bypassing FUSE)
- Fixes sandbox issues for Electron/Chromium
- Adds Cursor to your application launcher

---

### 📜 Installation Script

```bash
#!/bin/bash

set -e

APP_NAME="cursor"
INSTALL_DIR="$HOME/.local/bin/$APP_NAME"
DESKTOP_FILE="$HOME/.local/share/applications/$APP_NAME.desktop"
APPIMAGE_PATH="$HOME/Downloads/Cursor-1.0.0-x86_64.AppImage"  # Update if yours is in a different location

echo "🛠️ Cursor AppImage Linux Installer (local version)"

if [ ! -f "$APPIMAGE_PATH" ]; then
  echo "❌ File not found: $APPIMAGE_PATH"
  exit 1
fi

# Step 1: Extract AppImage
chmod +x "$APPIMAGE_PATH"
mkdir -p "$INSTALL_DIR"
"$APPIMAGE_PATH" --appimage-extract
mv squashfs-root/* "$INSTALL_DIR"

# Step 2: Fix chrome-sandbox permissions
CHROME_SANDBOX_PATH=$(find "$INSTALL_DIR" -type f -name chrome-sandbox | head -n 1)

if [ -n "$CHROME_SANDBOX_PATH" ]; then
  echo "🔐 Fixing chrome-sandbox at: $CHROME_SANDBOX_PATH"
  sudo chown root:root "$CHROME_SANDBOX_PATH"
  sudo chmod 4755 "$CHROME_SANDBOX_PATH"
else
  echo "⚠️ Could not find chrome-sandbox binary. Skipping sandbox fix."
fi

# Step 3: Create .desktop launcher
mkdir -p "$(dirname "$DESKTOP_FILE")"
ICON_PATH="$INSTALL_DIR/cursor.png"

ICON_CANDIDATES=(
  "$INSTALL_DIR/usr/share/icons/hicolor/512x512/apps/cursor.png"
  "$INSTALL_DIR/resources/app/assets/icon.png"
)

for candidate in "${ICON_CANDIDATES[@]}"; do
  if [ -f "$candidate" ]; then
    cp "$candidate" "$ICON_PATH"
    break
  fi
done

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
```

### 🧠 Notes
- The script bypasses the need for FUSE by extracting the AppImage manually.
- The chrome-sandbox binary needs setuid permissions (4755) or Cursor/Electron will crash.
- Customize the APPIMAGE_PATH variable if needed.