# Pixel 3a Root Setup - Manual Steps

Your device info:
- **Android 12**
- **Security Patch: May 5, 2022** 
- **Build ID: SP2A.220505.008**

## Step 1: Download Factory Image Manually

1. Go to: https://developers.google.com/android/images#sargo
2. Find the row with **Build ID: SP2A.220505.008**
3. Download the factory image zip file
4. Extract it to get `boot.img`

## Step 2: Install Magisk Manager

1. Download Magisk APK: https://github.com/topjohnwu/Magisk/releases
2. Install on your Pixel 3a
3. Open Magisk Manager

## Step 3: Patch Boot Image

1. Copy the extracted `boot.img` to your Pixel 3a
2. In Magisk Manager: Install → Select and Patch a File
3. Select the `boot.img` file
4. Magisk will create `magisk_patched_*.img`
5. Copy this patched file back to your computer

## Step 4: Flash Patched Boot

1. Reboot to bootloader: `adb reboot bootloader`
2. Flash patched boot: `fastboot flash boot magisk_patched_*.img`
3. Reboot: `fastboot reboot`

## Alternative: Use Magisk APK Method

Since downloading factory images can be tricky, we can use the simpler APK method:

1. Download latest Magisk APK
2. Rename .apk to .zip
3. Extract the boot.img from current device
4. Patch with Magisk app
5. Flash back

Would you like me to walk you through the APK method instead?
