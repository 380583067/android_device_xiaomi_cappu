# Copyright (C) 2018 The LineageOS Project

# Device path
DEVICE_PATH := device/xiaomi/cappu

TARGET_SPECIFIC_HEADER_PATH := $(DEVICE_PATH)/include

TARGET_OTA_ASSERT_DEVICE := cappu

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := cappu
TARGET_NO_BOOTLOADER := true

# Platform
TARGET_BOARD_PLATFORM := mt8173

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_VARIANT := generic
TARGET_CPU_ABI := arm64-v8a

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv7-a-neon
TARGET_2ND_CPU_VARIANT := cortex-a15
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi

TARGET_USES_64_BIT_BINDER := true

TARGET_CPU_SMP := true
ARCH_ARM_HAVE_TLS_REGISTER := true

# Kernel
BOARD_KERNEL_CMDLINE := bootopt=64S3,32N2,64N2 androidboot.selinux=permissive
BOARD_KERNEL_PAGESIZE := 2048
BOARD_KERNEL_BASE := 0x40078000
BOARD_KERNEL_OFFSET := 0x00008000
BOARD_RAMDISK_OFFSET := 0x08f88000
BOARD_TAGS_OFFSET := 0x0df88000
BOARD_SECOND_OFFSET := 0x00f00000
BOARD_MKBOOTIMG_ARGS := --base $(BOARD_KERNEL_BASE) --pagesize $(BOARD_KERNEL_PAGESIZE) --kernel_offset $(BOARD_KERNEL_OFFSET) --ramdisk_offset $(BOARD_RAMDISK_OFFSET) --tags_offset $(BOARD_TAGS_OFFSET) --second_offset $(BOARD_SECOND_OFFSET)
TARGET_KERNEL_ARCH := arm64

#Kernel Build
TARGET_KERNEL_SOURCE := kernel/xiaomi/cappu
TARGET_KERNEL_CONFIG := cappu_defconfig
# cappu 的 MT8173 3.18 内核使用原有 GCC 4.9；Android 12 默认 Clang 不适用。
# 使用构建系统自带绝对工具链路径，避免依赖主机 PATH 中同名编译器。
TARGET_KERNEL_CLANG_COMPILE := false
BOARD_KERNEL_IMAGE_NAME := Image.gz-dtb
MTK_APPENDED_DTB_SUPPORT := yes

# Bluetooth
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(DEVICE_PATH)/bluetooth
BOARD_HAVE_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_BCM_CUSTOM := true
BOARD_CUSTOM_BT_CONFIG := $(DEVICE_PATH)/bluetooth/vnd_config.txt

# Charger
BOARD_CHARGING_MODE_BOOTING_LPM := /sys/class/BOOT/BOOT/boot/boot_mode

# Enable dexpreopt to speed boot time
ifeq ($(HOST_OS),linux)
  ifeq ($(call match-word-in-list,$(TARGET_BUILD_VARIANT),user),true)
    ifeq ($(WITH_DEXPREOPT),)
      WITH_DEXPREOPT := true
      WITH_DEXPREOPT_BOOT_IMG_AND_SYSTEM_SERVER_ONLY := true
    endif
  endif
endif

# Filesystem
TARGET_USES_MKE2FS := true

# Mainfest
DEVICE_MANIFEST_FILE := $(DEVICE_PATH)/configs/manifest.xml
DEVICE_MATRIX_FILE   := $(DEVICE_PATH)/configs/compatibility_matrix.xml

# Partitions
BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 67108864
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_CACHEIMAGE_PARTITION_SIZE := 419430400
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 2684354560
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_PARTITION_SIZE := 872415232
BOARD_USERDATAIMAGE_PARTITION_SIZE := 6442450944
BOARD_FLASH_BLOCK_SIZE := 4096
BOARD_NEEDS_VENDORIMAGE_SYMLINK :=  true
TARGET_COPY_OUT_VENDOR := vendor
TARGET_USERIMAGES_USE_EXT4 := true
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true

# Recovery
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/rootdir/etc/fstab.mt8173
BOARD_HAS_LARGE_FILESYSTEM := true
TARGET_USE_CUSTOM_LUN_FILE_PATH := /sys/devices/soc/11270000.usb/gadget/lun%d/file

# Treble
PRODUCT_FULL_TREBLE_OVERRIDE := true
PRODUCT_VENDOR_MOVE_ENABLED := true
# Android 12 linkerconfig only exposes the system-side `sphal` namespace when
# the matching VNDK APEX is present. cappu's Android 7 vendor image predates
# VNDK, so build the platform's current VNDK package for its MTK EGL SP-HAL and
# VNDK-SP dependencies. The build system converts `current` to the platform's
# numeric runtime ro.vndk.version and auto-includes vndk_package; do not hardcode
# the string `current` as a runtime property in system.prop.
BOARD_VNDK_VERSION := current
# cappu Android 12：FCM level 在 manifest.xml 的 target-level 设置。
# 旧产品变量已被构建系统移除；API 27 对应 FCM 2。

# Graphics
TARGET_USES_HWC2 := true
TARGET_USES_HWC2ON1ADAPTER := false
TARGET_FORCE_HWC_FOR_VIRTUAL_DISPLAYS := true
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3
TARGET_RUNNING_WITHOUT_SYNC_FRAMEWORK := false

# Panel vsync offsets
PRESENT_TIME_OFFSET_FROM_VSYNC_NS := 0

# Seccomp filters
BOARD_SECCOMP_POLICY += $(DEVICE_PATH)/seccomp

# SELinux
# Xiaomi Mi Pad 3 shipped with Android Nougat (PRODUCT_SHIPPING_API_LEVEL=24).
# Android 12's S-launch-only property-owner check is not applicable to this
# legacy device; retain Treble property neverallows and partition boundaries.
BUILD_BROKEN_ENFORCE_SYSPROP_OWNER := true

BOARD_SEPOLICY_DIRS += \
        $(DEVICE_PATH)/sepolicy-mtk/basic/non_plat \
        $(DEVICE_PATH)/sepolicy-mtk/bsp/non_plat \
        $(DEVICE_PATH)/sepolicy-mt8173/basic \
        $(DEVICE_PATH)/sepolicy-mt8173/bsp \
        $(DEVICE_PATH)/sepolicy

# cappu Android 12：旧平台扩展策略归入 system_ext，保持与 vendor 策略分区。
SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS += \
        $(DEVICE_PATH)/sepolicy-mtk/basic/plat_public \
        $(DEVICE_PATH)/sepolicy-mtk/bsp/plat_public

SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += \
        $(DEVICE_PATH)/sepolicy-mtk/basic/plat_private \
        $(DEVICE_PATH)/sepolicy-mtk/bsp/plat_private

# WLAN
WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_bcmdhd
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WLAN_DEVICE := bcmdhd
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_bcmdhd
WIFI_DRIVER_FW_PATH_PARAM := "/sys/module/bcmdhd/parameters/firmware_path"
WIFI_DRIVER_FW_PATH_STA := "/vendor/firmware/fw_bcmdhd.bin"
WIFI_DRIVER_FW_PATH_AP := "/vendor/firmware/fw_bcmdhd_apsta.bin"
WIFI_DRIVER_FW_PATH_P2P := "/vendor/firmware/fw_bcmdhd.bin"

BOARD_USE_SOFT_GATEKEEPER := true
OVERRIDE_RS_DRIVER := libRSDriver_mtk.so

# cappu 内核已回移 memfd_create（mm/shmem.c），告知旧内核版本探测的客户端。
TARGET_HAS_MEMFD_BACKPORT := true
