#!/bin/bash

echo "=== Flash Magisk Patched Boot Image ==="
echo ""

echo "Looking for patched boot image on device..."
PATCHED_FILE=$(adb shell ls -t /storage/emulated/0/Download/ | grep "magisk_patched" | head -1 | tr -d '\r')

if [ -z "$PATCHED_FILE" ]; then
    echo "❌ No magisk_patched file found!"
    echo ""
    echo "Make sure you:"
    echo "1. Opened Magisk Manager on your device"
    echo "2. Selected 'Install' → 'Select and Patch a File'"
    echo "3. Selected the boot.img file"
    echo "4. Let Magisk complete the patching"
    exit 1
fi

echo "✓ Found patched boot image: $PATCHED_FILE"
echo ""

echo "Pulling patched boot image from device..."
adb pull "/storage/emulated/0/Download/$PATCHED_FILE" ./magisk_patched_boot.img

if [ ! -f "./magisk_patched_boot.img" ]; then
    echo "❌ Failed to pull patched boot image!"
    exit 1
fi

echo "✓ Patched boot image pulled successfully"

# Check file size (should be around 64MB like original boot.img)
PATCHED_SIZE=$(stat -f%z "./magisk_patched_boot.img" 2>/dev/null || stat -c%s "./magisk_patched_boot.img" 2>/dev/null)
echo "Patched boot image size: $PATCHED_SIZE bytes"

if [ "$PATCHED_SIZE" -lt 50000000 ]; then
    echo "❌ Patched boot image seems too small ($PATCHED_SIZE bytes)"
    echo "This might be corrupted. Aborting for safety."
    exit 1
fi

echo "✓ Patched boot image size looks good"

echo ""
echo "Rebooting to bootloader..."
adb reboot bootloader

echo "Waiting for bootloader..."
sleep 10

echo ""
echo "Checking device is in bootloader mode..."
fastboot devices

if [ $? -ne 0 ]; then
    echo "❌ Device not detected in bootloader mode!"
    echo "Please manually boot to bootloader and try again"
    exit 1
fi

echo "✓ Device detected in bootloader"
echo ""

echo "Getting current active slot..."
CURRENT_SLOT=$(fastboot getvar current-slot 2>&1 | grep "current-slot:" | cut -d: -f2 | tr -d ' ')
echo "Current active slot: $CURRENT_SLOT"

echo ""
echo "Flashing patched boot image to active slot (boot_$CURRENT_SLOT)..."
fastboot flash boot_$CURRENT_SLOT magisk_patched_boot.img

if [ $? -ne 0 ]; then
    echo "❌ Failed to flash boot_$CURRENT_SLOT!"
    exit 1
fi

echo "✓ boot_$CURRENT_SLOT flashed successfully"
echo "✓ Inactive slot preserved as backup"

echo ""
echo "Renaming patched boot image for future reference..."
mv magisk_patched_boot.img "magisk_patched_boot_$CURRENT_SLOT.img"
echo "✓ Saved as: magisk_patched_boot_$CURRENT_SLOT.img"

echo ""
echo "Rebooting to system..."
fastboot reboot

echo ""
echo "🎉 ROOTING COMPLETE!"
echo ""
echo "Your Pixel 3a should now be rooted with Magisk."
echo ""
echo "After it boots:"
echo "1. Open Magisk Manager to verify root"
echo "2. You can now install traffic analysis tools"
echo "3. Install SSL Kill Switch, Frida, etc."
echo ""
echo "Ready for traffic interception work!"
