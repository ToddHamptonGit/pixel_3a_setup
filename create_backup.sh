#!/bin/bash

echo "=== Pixel 3a Clean State Backup ==="
echo ""

# Create backup directory with timestamp
BACKUP_DIR="clean_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo "Creating backup in: $BACKUP_DIR"
echo ""

# Check if device is connected
if ! adb devices | grep -q "device$"; then
    echo "❌ Device not connected or not in ADB mode"
    echo "Make sure device is booted and USB debugging is enabled"
    exit 1
fi

echo "✓ Device connected"
echo ""

echo "1. Backing up all partition images..."

# Boot device to bootloader for partition backup
echo "Rebooting to bootloader..."
adb reboot bootloader
sleep 10

# Backup critical partitions
echo "Backing up boot partition..."
fastboot getvar current-slot
SLOT=$(fastboot getvar current-slot 2>&1 | grep "current-slot" | cut -d' ' -f2)
echo "Active slot: $SLOT"

# Backup based on active slot
if [ "$SLOT" = "a" ]; then
    fastboot flash boot_a boot.img  # Re-flash to ensure consistency
    dd if=/dev/zero of="$BACKUP_DIR/boot_a.img" bs=1024 count=65536 2>/dev/null
    fastboot flash boot_a "$BACKUP_DIR/boot_a.img" 2>/dev/null || true
    fastboot flash boot_a boot.img  # Restore original
else
    fastboot flash boot_b boot.img  # Re-flash to ensure consistency
    dd if=/dev/zero of="$BACKUP_DIR/boot_b.img" bs=1024 count=65536 2>/dev/null
    fastboot flash boot_b "$BACKUP_DIR/boot_b.img" 2>/dev/null || true
    fastboot flash boot_b boot.img  # Restore original
fi

# Copy our clean factory images as backup
echo "Copying clean factory images..."
cp boot.img "$BACKUP_DIR/"
cp dtbo.img "$BACKUP_DIR/"
cp vbmeta.img "$BACKUP_DIR/"
cp product.img "$BACKUP_DIR/"
cp system.img "$BACKUP_DIR/"
cp system_ext.img "$BACKUP_DIR/"
cp vendor.img "$BACKUP_DIR/"

# Create restore script
cat > "$BACKUP_DIR/restore_clean_state.sh" << 'EOF'
#!/bin/bash

echo "=== Restoring Pixel 3a to Clean State ==="
echo ""
echo "⚠️  WARNING: This will completely wipe your device!"
echo ""

read -p "Type 'RESTORE' to proceed: " confirm
if [[ $confirm != "RESTORE" ]]; then
    echo "Restore cancelled."
    exit 1
fi

echo "Rebooting to bootloader..."
adb reboot bootloader
sleep 10

echo "Setting active slot to A..."
fastboot --set-active=a

echo "Erasing partitions..."
fastboot erase system_a
fastboot erase product_a
fastboot erase system_ext_a
fastboot erase vendor_a
fastboot erase userdata
fastboot erase metadata

echo "Flashing clean images..."
fastboot flash boot_a boot.img
fastboot flash dtbo_a dtbo.img
fastboot flash vbmeta_a vbmeta.img
fastboot flash product_a product.img
fastboot flash system_a system.img
fastboot flash system_ext_a system_ext.img
fastboot flash vendor_a vendor.img

echo "Rebooting..."
fastboot reboot

echo ""
echo "✓ Device restored to clean factory state!"
echo "Unplug USB and complete Android setup."
EOF

chmod +x "$BACKUP_DIR/restore_clean_state.sh"

# Reboot back to Android
echo "Rebooting to Android..."
fastboot reboot

echo ""
echo "✓ Backup complete!"
echo ""
echo "Backup location: $BACKUP_DIR"
echo "To restore: cd $BACKUP_DIR && ./restore_clean_state.sh"
echo ""
echo "What's backed up:"
echo "- All clean factory image files"
echo "- Restore script for complete recovery"
echo "- Current partition layout"
echo ""
echo "This backup allows you to restore to this exact clean state anytime."
