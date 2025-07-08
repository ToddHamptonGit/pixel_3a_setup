#!/bin/bash

echo "=== Clean Factory Image Flash ==="
echo "This will completely wipe and restore your Pixel 3a"
echo ""

# Find the factory image file
FACTORY_FILE=$(ls sargo-sp2a.220505.008-factory-*.zip 2>/dev/null | head -1)

if [ -z "$FACTORY_FILE" ]; then
    echo "❌ Factory image not found!"
    echo "Please download sargo-sp2a.220505.008-factory-*.zip to this folder"
    exit 1
fi

echo "Found factory image: $FACTORY_FILE"
echo ""

# Check if device is in bootloader
if ! fastboot devices | grep -q "fastboot"; then
    echo "❌ Device not in bootloader mode"
    echo ""
    echo "Please:"
    echo "1. Connect your Pixel 3a via USB"
    echo "2. Run: adb reboot bootloader"
    echo "3. Wait for bootloader screen"
    echo "4. Run this script again"
    exit 1
fi

echo "✓ Device in bootloader mode"
echo ""

echo "⚠️  FINAL WARNING ⚠️"
echo "This will completely erase everything on your device!"
echo "All partitions will be overwritten with clean factory images."
echo ""
read -p "Type 'CLEAN FLASH' to proceed: " confirm
if [[ $confirm != "CLEAN FLASH" ]]; then
    echo "Flash cancelled."
    exit 1
fi

echo ""
echo "Extracting factory image..."
rm -rf factory_extracted
mkdir factory_extracted
cd factory_extracted
unzip -q "../$FACTORY_FILE"

# Find the extracted folder
EXTRACTED_DIR=$(ls -d sargo-sp2a.220505.008 2>/dev/null)
if [ -z "$EXTRACTED_DIR" ]; then
    echo "❌ Failed to extract factory image"
    exit 1
fi

cd "$EXTRACTED_DIR"

echo "✓ Factory image extracted"
echo ""
echo "Running flash-all script..."
echo "(This will take several minutes)"

# Run the official flash script
chmod +x flash-all.sh
./flash-all.sh

echo ""
echo "=== Flash Complete ==="
echo "Your device should reboot automatically with a clean factory image."
echo "After reboot, you'll need to go through setup again."
echo ""
echo "Next steps:"
echo "1. Complete Android setup"
echo "2. Enable Developer Options and USB Debugging"
echo "3. Root the device with Magisk"
