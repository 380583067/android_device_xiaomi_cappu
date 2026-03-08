# Copyright (C) 2018 The LineageOS Project

$(call inherit-product, device/xiaomi/cappu/device.mk)

# Inherit some common Lineage stuff.
$(call inherit-product, vendor/lineage/config/common_full_tablet_wifionly.mk)

PRODUCT_BRAND := Xiaomi
PRODUCT_DEVICE := cappu
PRODUCT_MANUFACTURER := Xiaomi
PRODUCT_MODEL := Mi Pad 3
PRODUCT_NAME := lineage_cappu
PRODUCT_RELEASE_NAME := cappu
PRODUCT_RESTRICT_VENDOR_FILES := false

PRODUCT_GMS_CLIENTID_BASE := android-xiaomi
