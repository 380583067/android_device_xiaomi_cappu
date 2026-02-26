$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, device/xiaomi/cappu/device.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)
$(call inherit-product, vendor/cm/config/common_full_tablet_wifionly.mk)

PRODUCT_BRAND := Xiaomi
PRODUCT_DEVICE := cappu
PRODUCT_MANUFACTURER := Xiaomi
PRODUCT_MODEL := Mi Pad 3
PRODUCT_NAME := lineage_cappu
PRODUCT_RELEASE_NAME := cappu

