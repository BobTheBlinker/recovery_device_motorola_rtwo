Device configuration for Moto Edge+ (2023) (codenamed "rtwo")
=========================================

The Motorola Moto Edge+ (2023) (codenamed _"rtwo"_) is a upper-range smartphone from Motorola Mobility announced in May 2023.

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
Display | OLED, 165 Hz, 2400 x 1080 pixels, 6.67 inches (~395 ppi density)
Camera  | 50MP (Wide) + 50MP (Ultra-wide) + 12MP (Telephoto) + 60MP (Selfie)

## Device picture
![Motorola Moto Edge+ (2023)](https://fdn2.gsmarena.com/vv/bigpic/motorola-edge-plus-2023.jpg)

# Status
Current state of features:
- [ ] Correct screen/recovery size
- [ ] Working touch, display
- [ ] Screen goes off and on
- [ ] Backup/restore to/from internal/external storage and adb
- [ ] Poweroff
- [ ] Reboot to system, bootloader, recovery, fastboot, edl
- [ ] ADB (including sideload)
- [ ] Support EROFS/F2FS/EXT4/exFAT/FAT32/NTFS
- [ ] Decrypt /data
- [ ] Flashing zip/images
- [ ] MTP export
- [ ] All important partitions listed in wipe/mount/backup lists
- [ ] Input devices via USB-OTG
- [ ] USB mass storage export
- [ ] Correct date
- [ ] Battery level
- [ ] Set brightness
- [ ] Vibrate and set vibration
- [ ] Screenshot
- [ ] Advanced features

# Building
```bash
export ALLOW_MISSING_DEPENDENCIES=true
source build/envsetup.sh
lunch twrp_rtwo-eng
mka recoveryimage -j$(nproc --all)
```

**Copyright (C) 2023 Team Win Recovery Project**<br>
**Copyright (C) 2025 A-Team Digital Solutions**
