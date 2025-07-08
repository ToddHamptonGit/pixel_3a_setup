#!/bin/bash

echo "=== Extract Boot Image from Device ==="
echo ""

# First make sure device is connected
if ! adb devices | grep -q "device$"; then
    echo "❌ Device not connected or unauthorized"
    echo "Make sure your Pixel 3a is connected and USB debugging is enabled"
    exit 1
fi

echo "✓ Device connected"
echo ""

# Extract boot image directly from device
echo "Extracting boot.img from your device..."
adb shell su -c "dd if=/dev/block/by-name/boot_a of=/sdcard/boot.img" 2>/dev/null

if [ $? -ne 0 ]; then
    echo "Device not rooted yet. Using alternative method..."
    echo "Downloading boot.img from device partition..."
    
    # Try without su (this will work on unlocked bootloader)
    adb shell "dd if=/dev/block/by-name/boot_a of=/sdcard/boot.img"
    
    if [ $? -ne 0 ]; then
        echo "❌ Cannot extract boot image directly"
        echo ""
        echo "We need to download the factory image manually."
        echo "Please download it from: https://developers.google.com/android/images#sargo"
        echo "Look for build: SP2A.220505.008"
        exit 1
    fi
fi

# Pull the boot image to computer
echo "Copying boot.img to computer..."
adb pull /sdcard/boot.img boot_original.img

if [ -f "boot_original.img" ]; then
    echo "✓ boot_original.img extracted successfully!"
    echo ""
    echo "File size: $(ls -lh boot_original.img | awk '{print $5}')"
    echo ""
    echo "Next: Download and install Magisk Manager APK on your device"
    echo "Then run: ./patch_boot_with_magisk.sh"
else
    echo "❌ Failed to extract boot image"
fi
