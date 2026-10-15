#
# Copyright (C) 2023 The Android Open Source Project
# Copyright (C) 2019-Present A-Team Digital Solutions
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/motorola/rtwo

# Bootloader
BOARD_VENDOR := motorola
TARGET_SOC := kalama
TARGET_BOOTLOADER_BOARD_NAME := kalama
TARGET_NO_BOOTLOADER := true
TARGET_NO_RADIOIMAGE := true
TARGET_USES_UEFI := true

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-2a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_VARIANT := generic

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-2a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := generic

ALLOW_MISSING_DEPENDENCIES := true

# File systems
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true

# Platform
BOARD_USES_QCOM_HARDWARE := true
TARGET_BOARD_PLATFORM := kalama
QCOM_BOARD_PLATFORMS += kalama

# Boot
BOARD_BOOT_HEADER_VERSION := 4
BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE := true
TARGET_NO_KERNEL := true
BOARD_KERNEL_PAGESIZE := 4096
BOARD_KERNEL_BASE := 0x00000000
BOARD_RAMDISK_USE_LZ4 := true
BOARD_USES_GENERIC_KERNEL_IMAGE := true
BOARD_CUSTOM_BOOTIMG_MK := $(DEVICE_PATH)/bootimg.mk

# Recovery
BOARD_HAS_LARGE_FILESYSTEM := true
BOARD_HAS_NO_SELECT_BUTTON := true
RECOVERY_SDCARD_ON_DATA := true
TARGET_RECOVERY_QCOM_RTC_FIX := true
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888

# Partitions
BOARD_FLASH_BLOCK_SIZE := 262144
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 104857600

# Super Partitions
BOARD_SUPER_PARTITION_SIZE := 9940500480
BOARD_MOT_DP_GROUP_SIZE := 9936306176
BOARD_MOT_DP_GROUP_PARTITION_LIST := product system system_ext vendor vendor_dlkm
BOARD_SUPER_PARTITION_GROUPS := mot_dp_group

# System as root
BOARD_ROOT_EXTRA_FOLDERS := \
	data_mirror \
	linkerconfig \
	postinstall \
	second_stage_resources \
	system_ext \
	vendor_dlkm
BOARD_SUPPRESS_SECURE_ERASE := true

# Workaround for error copying vendor files to recovery ramdisk
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_VENDOR := vendor

# Properties
TARGET_VENDOR_PROP += $(DEVICE_PATH)/vendor.prop

AB_OTA_UPDATER := true

AB_OTA_PARTITIONS += \
    boot \
    dtbo \
    init_boot \
    product \
    recovery \
    system \
    system_dlkm \
    system_ext \
    vbmeta \
    vbmeta_system \
    vendor \
    vendor_dlkm \
    vendor_boot

# Crypto
TW_INCLUDE_CRYPTO := true
TW_INCLUDE_CRYPTO_FBE := true
BOARD_USES_QCOM_FBE_DECRYPTION := true
TW_INCLUDE_FBE_METADATA_DECRYPT := true
BOARD_USES_METADATA_PARTITION := true

# PRODUCT_COPY_FILES directives.
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true

# Only what first-stage init does not already load: ADSP (battery charger runs on it) and the crypto engine
TW_LOAD_VENDOR_MODULES := "adsp_loader_dlkm.ko qce50_dlkm.ko qcedev-mod_dlkm.ko qcrypto-msm_dlkm.ko qrng_dlkm.ko"
TW_LOAD_VENDOR_BOOT_MODULES := true
TW_LOAD_VENDOR_MODULES_EXCLUDE_GKI := true

# TWRP specific build flags
TW_THEME := portrait_hdpi
TW_DEVICE_VERSION := A-Team_v1.3
TW_FRAMERATE := 120
TW_MAX_BRIGHTNESS := 16380
TW_DEFAULT_BRIGHTNESS := 7164
TW_BRIGHTNESS_PATH := "/sys/class/backlight/panel0-backlight/brightness"
TW_CUSTOM_CPU_TEMP_PATH := /sys/class/thermal/thermal_zone31/temp
TW_SCREEN_BLANK_ON_BOOT := true
TW_EXCLUDE_APEX := true
TW_EXCLUDE_DEFAULT_USB_INIT := true
TW_INCLUDE_NTFS_3G := true
TW_SUPPORT_INPUT_AIDL_HAPTICS := true
TW_USE_NEW_MINADBD := true
TW_USE_TOOLBOX := true
TARGET_USES_MKE2FS := true
TW_NO_LEGACY_PROPS := true
TW_NO_BIND_SYSTEM := true
TW_USE_MODEL_HARDWARE_ID_FOR_DEVICE_ID := true
TW_EXTRA_LANGUAGES := true
TW_BACKUP_EXCLUSIONS := /data/fonts
TW_INCLUDE_REPACKTOOLS := true
TW_INCLUDE_LIBRESETPROP := true
TW_INCLUDE_RESETPROP := true
TWRP_INCLUDE_LOGCAT := true
TARGET_USES_LOGD := true
TW_INCLUDE_LPDUMP := true
TW_INCLUDE_LPTOOLS := true

# Statusbar icons flags
TW_STATUS_ICONS_ALIGN := center
TW_CUSTOM_CPU_POS := 580
TW_CUSTOM_CLOCK_POS := 50
TW_CUSTOM_BATTERY_POS := 800
TW_HAS_EDL_MODE := true
# End*

# AERA 16: scale the UI to the panel
AERA_UI_ADAPTIVE_RESOLUTION := true

# AERA 16: prebuilt magiskboot is 4K-aligned; skip the 16K ELF check
BUILD_BROKEN_PREBUILT_ELF_FILES := true

# AERA 16: wifi userspace (wpa_supplicant, wpa_cli, dhcptool, rclone)
AERA_ENABLE_WLAN := 1

# AERA 16: busybox (AERA downloads plugins/catalog with busybox wget)
AERA_USE_BUSYBOX_BINARY := 1
