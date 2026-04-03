# Copyright (C) 2018 The LineageOS Project

# Inherit device configuration for cappu.
# Inherit some common lineage stuff.
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/product_launched_with_n.mk)
# Dalvik heap configurations
$(call inherit-product-if-exists, frameworks/native/build/phone-xxhdpi-3072-dalvik-heap.mk)
# Call hwui memory config
$(call inherit-product-if-exists, frameworks/native/build/phone-xxhdpi-3072-hwui-memory.mk)

# Inherit from xiaomi device
$(call inherit-product, device/xiaomi/cappu/device.mk)

# Inherit some common Lineage stuff.
$(call inherit-product, vendor/lineage/config/common_full_tablet_wifionly.mk)

# Device identifier
PRODUCT_BRAND := Xiaomi
PRODUCT_DEVICE := cappu
PRODUCT_MANUFACTURER := Xiaomi
PRODUCT_MODEL := Mi Pad 3
PRODUCT_NAME := lineage_cappu
PRODUCT_RELEASE_NAME := cappu

PRODUCT_GMS_CLIENTID_BASE := android-xiaomi

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="lineage_cappu-userdebug-8.1.0-OPM7.181205.001-9fec313e91-test-keys"

BUILD_FINGERPRINT := Xiaomi/lineage_cappu/cappu:8.1.0/OPM7.181205.001/9fec313e91:userdebug/test-keys
