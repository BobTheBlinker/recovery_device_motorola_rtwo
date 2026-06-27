Device configuration for Moto Edge+ (2023) (codenamed "rtwo")
=========================================

The Motorola Moto Edge+ (2023) (codenamed _"rtwo"_) is an upper-range smartphone from Motorola Mobility announced in May 2023.

## Device specifications

Basic   | Spec Sheet
-------:|:-------------------------
SoC     | Qualcomm SM8550-AB Snapdragon 8 Gen 2 (4 nm)
CPU     | Octa-core (1x3.2 GHz Cortex-X3 & 2x2.8 GHz Cortex-A715 & 2x2.8 GHz Cortex-A710 & 3x2.0 GHz Cortex-A510)
GPU     | Adreno 740
Memory  | 8 GB RAM (LPDDR4X)
Shipped Android Version | 13.0, My UX 3.0 (Global)
Storage | 512 GB (UFS 4.0)
Battery | Non-removable Li-Po 5100 mAh battery
Display | LTPS, 120 Hz, 2400 x 1080 pixels, 6.67 inches (~403 ppi density)
Camera  | 50MP (Wide) + 12MP (Telephoto) + 50MP (Ultra-wide) + 60MP (Selfie)

## Device picture
![Motorola Moto Edge+ (2023)](https://fdn2.gsmarena.com/vv/bigpic/motorola-edge-plus-2023.jpg)

# Status
Current state of features:
- [X] Correct screen/recovery size
- [X] Working touch, display
- [x] Screen goes off and on
- [X] Backup/restore to/from internal/external storage and adb
- [X] Poweroff
- [X] Reboot to system, bootloader, recovery, fastboot, edl
- [X] ADB (including sideload)
- [X] Support EROFS/F2FS/EXT4/exFAT/FAT32/NTFS
- [X] Decrypt /data
- [X] Flashing zip/images
- [X] MTP export
- [X] All important partitions listed in wipe/mount/backup lists
- [X] Input devices via USB-OTG
- [X] USB mass storage export
- [X] Correct date
- [X] Battery level
- [X] Set brightness
- [X] Vibrate and set vibration
- [X] Screenshot
- [X] Advanced features

# Building
```bash
export ALLOW_MISSING_DEPENDENCIES=true
source build/envsetup.sh
lunch twrp_rtwo-eng
mka recoveryimage -j$(nproc --all)
```

**Copyright (C) 2023 Team Win Recovery Project**<br>
**Copyright (C) 2025 A-Team Digital Solutions**
