# Pixel 3a Boot Loop Fix - A/B Partition Issues

## Problem
After flashing factory image, device gets stuck in boot loop returning to fastboot screen with error:
```
Resizing 'system_a' FAILED (remote: 'Not enough space to resize partition')
```

## Root Cause
- Device previously had newer Android version (13/14) flashed
- Partition layout conflicts when downgrading to Android 12
- A/B slots have mismatched partition sizes
- Standard `flash-all.sh` fails due to partition resize conflicts

## Solution: Manual A/B Slot Flash

### Step 1: Clear Conflicting Partitions
```bash
# Clear B slot partitions first
fastboot erase system_a
fastboot erase system_b  
fastboot erase vendor_a
fastboot erase vendor_b  # (may not exist)
fastboot erase userdata
fastboot erase metadata
```

### Step 2: Run flash-all.sh
```bash
./flash-all.sh
# This will likely fail at the end with system_a resize error, but B slot will be flashed
```

### Step 3: Manual A Slot Flash
```bash
# Switch to A slot
fastboot --set-active=a

# Clear A slot partitions
fastboot erase system_a
fastboot erase product_a
fastboot erase system_ext_a
fastboot erase vendor_a

# Flash A slot manually
fastboot flash boot_a boot.img
fastboot flash dtbo_a dtbo.img
fastboot flash vbmeta_a vbmeta.img
fastboot flash product_a product.img
fastboot flash system_a system.img
fastboot flash system_ext_a system_ext.img
fastboot flash vendor_a vendor.img

# Final cleanup
fastboot erase userdata
fastboot erase metadata
fastboot reboot
```

### Step 4: Disconnect USB and Boot
- Unplug USB cable
- Device should boot to "Get started" screen

## Key Points
- This affects devices that had newer Android versions previously
- Standard flash-all.sh alone is insufficient for partition conflicts
- Manual partition clearing + individual flashing resolves the issue
- Both A and B slots need to be properly flashed
- Works for Pixel 3a (sargo) and likely other A/B devices

## Success Indicators
- No "resize partition" errors during manual flash
- Device boots to Android setup instead of fastboot loop
- Clean factory Android installation achieved

## Credit
Solution derived from systematic A/B partition troubleshooting methodology.
