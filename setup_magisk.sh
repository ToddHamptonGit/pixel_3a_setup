#!/bin/bash

echo "=== Pixel 3a Rooting with Magisk ==="
echo ""

# Check if we have the boot image
if [ ! -f "clean_factory_backup/boot.img" ]; then
    echo "❌ boot.img not found!"
    echo "Make sure you're in the pixel_3a_setup directory"
    exit 1
fi

echo "✓ boot.img found"
echo ""

echo "Step 1: Download latest Magisk APK"
echo "Downloading Magisk..."

# Download latest Magisk APK
MAGISK_URL="https://github.com/topjohnwu/Magisk/releases/latest/download/Magisk-v27.0.apk"
curl -L -o "Magisk-v27.0.apk" "$MAGISK_URL"

if [ ! -f "Magisk-v27.0.apk" ]; then
    echo "❌ Failed to download Magisk APK"
    echo "Please download manually from: https://github.com/topjohnwu/Magisk/releases"
    exit 1
fi

echo "✓ Magisk APK downloaded"
echo ""

echo "Step 2: Install Magisk APK on device"
adb install Magisk-v27.0.apk

echo ""
echo "Step 3: Copy boot.img to device (in Download folder for Magisk access)"
adb push clean_factory_backup/boot.img /sdcard/Download/boot.img

echo ""
echo "=== MANUAL STEPS REQUIRED ==="
echo ""
echo "Now you need to:"
echo "1. Open Magisk Manager app on your device"
echo "2. Tap 'Install' next to Magisk"
echo "3. Select 'Select and Patch a File'"
echo "4. Navigate to and select the boot.img file (it should be in Downloads folder)"
echo "5. Let Magisk patch the boot image"
echo "6. This will create a file like 'magisk_patched_XXXXX.img'"
echo ""
echo "When done, run: ./flash_magisk_boot.sh"
echo ""
echo "This will pull the patched boot image and flash it to root your device."
