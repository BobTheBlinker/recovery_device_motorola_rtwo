# Copyright (C) 2024 The Android Open Source Project
# Copyright (C) 2024 SebaUbuntu's TWRP device tree generator
# Copyright (C) 2019 - Current | A-Team Digital Solutions

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit some common TWRP stuff.
$(call inherit-product, vendor/twrp/config/common.mk)

# Inherit from rtwo device
$(call inherit-product, device/motorola/rtwo/device.mk)

PRODUCT_DEVICE := rtwo
PRODUCT_NAME := twrp_rtwo
PRODUCT_BRAND := motorola
PRODUCT_MODEL := motorola edge+ (2023)
PRODUCT_MANUFACTURER := motorola

PRODUCT_GMS_CLIENTID_BASE := android-motorola

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="rtwo_g-user 14 U1TRS34.8-30-13-1 7c77a-12bae6 release-keys"

BUILD_FINGERPRINT := motorola/rtwo_g/rtwo:14/U1TRS34.8-30-13-1/7c77a-12bae6:user/release-keys
