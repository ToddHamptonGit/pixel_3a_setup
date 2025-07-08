#!/bin/bash

# Pixel 3a Rooting Setup
# Build: SP2A.220505.008 (Android 12, May 2022)

echo "=== Pixel 3a Rooting Setup ==="
echo "Build ID: SP2A.220505.008"
echo ""

# Create downloads directory
mkdir -p downloads
cd downloads

echo "Downloading factory image for your build..."
# Factory image for Pixel 3a (sargo) - Android 12, May 2022 security patch
FACTORY_URL="https://dl.google.com/dl/android/aosp/sargo-sp2a.220505.008-factory-6b993072.zip"
FACTORY_FILE="sargo-sp2a.220505.008-factory-6b993072.zip"

if [ ! -f "$FACTORY_FILE" ]; then
    echo "Downloading factory image..."
    curl -L -o "$FACTORY_FILE" "$FACTORY_URL"
    if [ $? -ne 0 ]; then
        echo "❌ Download failed. You may need to download manually from:"
        echo "https://developers.google.com/android/images#sargo"
        echo "Look for build SP2A.220505.008"
        exit 1
    fi
else
    echo "✓ Factory image already downloaded"
fi

echo ""
echo "Extracting boot.img..."
unzip -q "$FACTORY_FILE"
cd sargo-sp2a.220505.008
unzip -q image-sargo-sp2a.220505.008.zip

if [ -f "boot.img" ]; then
    echo "✓ boot.img extracted successfully"
    cp boot.img ../boot_original.img
    echo ""
    echo "Next steps:"
    echo "1. Install Magisk Manager APK on your device"
    echo "2. Copy boot_original.img to your device"
    echo "3. Patch it with Magisk"
    echo "4. Copy patched boot back to computer"
    echo "5. Flash the patched boot image"
else
    echo "❌ Failed to extract boot.img"
    exit 1
fi
