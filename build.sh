#!/bin/bash

set -e

APP_NAME="MacThermal"
SOURCE="Sources/MacThermal.swift"

BUILD_ROOT="/tmp/MacThermalBuild"
APP_DIR="$BUILD_ROOT/$APP_NAME.app"

echo "Building $APP_NAME..."

# Clean temporary build directory
rm -rf "$BUILD_ROOT"

# Create app structure
mkdir -p "$APP_DIR/Contents/MacOS"
mkdir -p "$APP_DIR/Contents/Resources"
# Compile
swiftc -parse-as-library "$SOURCE" \
-o "$APP_DIR/Contents/MacOS/$APP_NAME" \
-framework SwiftUI \
-framework AppKit \
-framework Foundation \
-framework Combine

cp Assets/MacThermal-v2.icns "$APP_DIR/Contents/Resources/MacThermal-v2.icns"
# Create Info.plist
cat > "$APP_DIR/Contents/Info.plist" <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
"http://www.apple.com/DTDs/PropertyList-1.0.dtd">

<plist version="1.0">
<dict>
    <key>CFBundleName</key>
    <string>MacThermal</string>

    <key>CFBundleDisplayName</key>
    <string>MacThermal</string>

    <key>CFBundleIdentifier</key>
    <string>local.macthermal.app</string>

    <key>CFBundleExecutable</key>
    <string>MacThermal</string>

<key>CFBundleIconFile</key>
<string>MacThermal-v2.icns</string>

    <key>CFBundlePackageType</key>
    <string>APPL</string>

    <key>CFBundleShortVersionString</key>
<string>1.0.2</string>

<key>CFBundleVersion</key>
<string>3</string>

    <key>LSUIElement</key>
    <true/>
</dict>
</plist>
EOF

# Remove Finder / FileProvider metadata
xattr -cr "$APP_DIR"

# Local ad-hoc signature
codesign --force --sign - "$APP_DIR"
# Verify signature
codesign --verify --verbose=2 "$APP_DIR"

echo ""
echo "✓ Build successful"
echo ""
echo "App:"
echo "$APP_DIR"
echo ""
echo "Run with:"
echo "open $APP_DIR"
