#!/bin/bash

echo "=== Restore Pixel 3a to Clean Factory State ==="
echo ""
echo "This will restore your device to the exact clean state we achieved"
echo "after fixing the partition issues."
echo ""
echo "⚠️  WARNING: This will completely wipe your device!"
echo "⚠️  All data, apps, and modifications will be lost!"
echo ""

read -p "Type 'RESTORE CLEAN' to proceed: " confirm
if [[ $confirm != "RESTORE CLEAN" ]]; then
    echo "Restore cancelled."
    exit 1
fi

echo ""
echo "Step 1: Rebooting to bootloader..."
adb reboot bootloader
echo "Waiting for bootloader..."
sleep 10

echo ""
echo "Step 2: Setting active slot to A..."
fastboot --set-active=a

echo ""
echo "Step 3: Erasing conflicting partitions..."
fastboot erase system_a
fastboot erase product_a  
fastboot erase system_ext_a
fastboot erase vendor_a
fastboot erase userdata
fastboot erase metadata

echo ""
echo "Step 4: Flashing clean factory images..."
fastboot flash boot_a boot.img
fastboot flash dtbo_a dtbo.img
fastboot flash vbmeta_a vbmeta.img
fastboot flash product_a product.img
fastboot flash system_a system.img
fastboot flash system_ext_a system_ext.img
fastboot flash vendor_a vendor.img

echo ""
echo "Step 5: Final cleanup..."
fastboot erase userdata
fastboot erase metadata

echo ""
echo "Step 6: Rebooting..."
fastboot reboot

echo ""
echo "✅ RESTORE COMPLETE!"
echo ""
echo "Your device is now restored to the clean factory state."
echo "🔌 Unplug USB cable and let it boot independently"
echo "📱 You should see the 'Get started' setup screen"
echo ""
echo "Ready to proceed with rooting or development work!"
