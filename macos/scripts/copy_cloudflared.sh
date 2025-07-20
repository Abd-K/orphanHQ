#!/bin/bash

# Script to copy cloudflared into the app bundle
# This allows the Flutter app to execute cloudflared without permission issues

APP_BUNDLE="$BUILT_PRODUCTS_DIR/$PRODUCT_NAME.app"
CLOUDFLARED_SOURCE="/opt/homebrew/bin/cloudflared"
CLOUDFLARED_DEST="$APP_BUNDLE/Contents/MacOS/cloudflared"

echo "Copying cloudflared to app bundle..."

# Check if cloudflared exists
if [ ! -f "$CLOUDFLARED_SOURCE" ]; then
    echo "Error: cloudflared not found at $CLOUDFLARED_SOURCE"
    echo "Please install cloudflared: brew install cloudflare/cloudflare/cloudflared"
    exit 1
fi

# Copy cloudflared to app bundle
cp "$CLOUDFLARED_SOURCE" "$CLOUDFLARED_DEST"

# Make it executable
chmod +x "$CLOUDFLARED_DEST"

echo "✅ cloudflared copied to $CLOUDFLARED_DEST" 