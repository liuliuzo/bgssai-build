#!/bin/bash
# Registration script for bgssai-build:// custom protocol

set -e

# Create a handler script
HANDLER_BIN="$HOME/.local/bin/bgssai-build-handler"
mkdir -p "$HOME/.local/bin"
cat << 'INNER' > "$HANDLER_BIN"
#!/bin/bash
echo "======================================"
echo " bgssai-build protocol triggered!"
echo " URL Received: $1"
echo "======================================"
# Extract parameters
URL="$1"
# Real implementation would pass this to the rust binary
# bgssai-build --sync-doc "$URL"
notify-send "bgssai-build 唤醒成功" "接收到任务: $URL"
INNER
chmod +x "$HANDLER_BIN"

# Create the .desktop file
DESKTOP_FILE="$HOME/.local/share/applications/bgssai-build.desktop"
mkdir -p "$HOME/.local/share/applications"
cat << INNER > "$DESKTOP_FILE"
[Desktop Entry]
Name=bgssai-build
Exec=$HANDLER_BIN %u
Type=Application
Terminal=true
MimeType=x-scheme-handler/bgssai-build;
INNER

# Register the protocol
xdg-mime default bgssai-build.desktop x-scheme-handler/bgssai-build
update-desktop-database "$HOME/.local/share/applications" || true

echo "Protocol bgssai-build:// successfully registered on Linux."
