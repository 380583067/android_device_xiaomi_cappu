#
# Copyright (C) 2018 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# mt6753 platform boardconfig
LOCAL_DONT_CHECK_LIBRARIES := true

# Path
LOCAL_PATH := device/xiaomi/cappu

# Audio
BOARD_USES_MTK_AUDIO := true
USE_XML_AUDIO_POLICY_CONF := 1

# Binder API
TARGET_USES_64_BIT_BINDER := true
BOARD_USES_BPF := false

# Bluetooth
MTK_BT_SUPPORT := yes
BOARD_HAVE_BLUETOOTH := true
BOARD_BLUETOOTH_DOES_NOT_USE_RFKILL := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(LOCAL_PATH)/bluetooth

# Boot animation
TARGET_SCREEN_HEIGHT := 2048
TARGET_SCREEN_WIDTH := 1536
TARGET_BOOTANIMATION_HALF_RES := true
TARGET_BOOTANIMATION_MULTITHREAD_DECODE := true

# Camera
USE_CAMERA_STUB := true

# ELF
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true
BUILD_BROKEN_PREBUILT_ELF_FILES := true
LOCAL_CHECK_ELF_FILES := false

# los hardware
BOARD_HARDWARE_CLASS := $(LOCAL_PATH)/lineagehw

# MTK Hardware
BOARD_HAS_MTK_HARDWARE := true
BOARD_USES_MTK_HARDWARE := true
MTK_HARDWARE := true

# Legacy blobs
TARGET_NEEDS_PLATFORM_TEXT_RELOCATIONS := true

# Architecture Extensions
ARCH_ARM_HAVE_TLS_REGISTER := true

# Disable memcpy opt (for audio libraries)
TARGET_CPU_MEMCPY_OPT_DISABLE := true

# Flags
BOARD_GLOBAL_CFLAGS += -DNO_SECURE_DISCARD
TARGET_RUNNING_WITHOUT_SYNC_FRAMEWORK := true

# Fonts
EXTENDED_FONT_FOOTPRINT := true

# Platform
TARGET_BOARD_PLATFORM := mt8173
TARGET_NO_BOOTLOADER := true
TARGET_NO_FACTORYIMAGE := true

# CPU
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_VARIANT := generic
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_SMP := true
TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv7-a-neon
TARGET_2ND_CPU_VARIANT := cortex-a15
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
ENABLE_CPUSETS := true

# --- 平台与架构定义 ---
TARGET_BOARD_PLATFORM := mt8173
TARGET_BOOTLOADER_BOARD_NAME := mt8173

# GPU核心配置
BOARD_GPU_DRIVER := powervr
TARGET_BOARD_GPU := G6200
TARGET_USES_POWERVR_GPU := true

# Gralloc配置（强制gralloc 1.0，兼容老驱动）
BOARD_USES_GENERIC_GRALLOC := false
BOARD_USES_MTK_GRALLOC := true
BOARD_USES_GRALLOC1 := true
TARGET_USES_GRALLOC1 := true
BOARD_GRALLOC_VERSION := 1

# HWC配置（强制HWC 1.4，完全禁用HWC2）
TARGET_USES_HWC2 := false
TARGET_USES_HWC1 := true
BOARD_HAS_HWC := true
BOARD_USES_MTK_HWC := true

# 显示缓冲区配置
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3
TARGET_DISABLE_TRIPLE_BUFFERING := false
TARGET_FORCE_HWC_FOR_VIRTUAL_DISPLAYS := true

# 关闭Android 10不兼容的高级特性
TARGET_USES_COLOR_METADATA := false
TARGET_USES_HDR10 := false
TARGET_USES_HDR10_PLUS := false

# 针对 PowerVR GPU 节点添加 Zygote 白名单 添加 PowerVR 核心节点
ZYGOTE_WHITELIST_PATH_EXTRA := "/dev/pvr_sync","/dev/pvrsrvkm"

# Kernel
BOARD_KERNEL_CMDLINE := bootopt=64S3,32N2,64N2 console=ttyMT0,921600n1 androidboot.selinux=permissive
BOARD_KERNEL_PAGESIZE := 2048
BOARD_NAME := 1479347649
BOARD_KERNEL_BASE := 0x40078000
BOARD_KERNEL_OFFSET := 0x00008000
BOARD_RAMDISK_OFFSET := 0x08f88000
BOARD_TAGS_OFFSET := 0x0df88000
BOARD_SECOND_OFFSET := 0x00f00000
BOARD_MKBOOTIMG_ARGS := --board $(BOARD_NAME) --base $(BOARD_KERNEL_BASE) --pagesize $(BOARD_KERNEL_PAGESIZE) --kernel_offset $(BOARD_KERNEL_OFFSET) --ramdisk_offset $(BOARD_RAMDISK_OFFSET) --tags_offset $(BOARD_TAGS_OFFSET) --second_offset $(BOARD_SECOND_OFFSET)
TARGET_KERNEL_ARCH := arm64

# Kernel Build
TARGET_KERNEL_SOURCE := kernel/xiaomi/cappu
TARGET_KERNEL_CONFIG := cappu_defconfig
BOARD_KERNEL_IMAGE_NAME := Image.gz-dtb
MTK_APPENDED_DTB_SUPPORT := yes

# FS
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_EXFAT_DRIVER := sdfat
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USES_MKE2FS := true

# Enable MALLOC
MALLOC_SVELTE := true

# Partitions
BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 67108864
BOARD_CACHEIMAGE_PARTITION_SIZE := 419430400
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 2684354560
BOARD_USERDATAIMAGE_PARTITION_SIZE := 6442450944
BOARD_FLASH_BLOCK_SIZE := 131072

BOARD_HAS_LARGE_FILESYSTEM := true
TARGET_USERIMAGES_USE_EXT4 := true

# LightHAL
TARGET_PROVIDES_LIBLIGHT := true

# Sensors
TARGET_NO_SENSOR_PERMISSION_CHECK := true

# Recovery
BOARD_HAS_LARGE_FILESYSTEM := true
TARGET_RECOVERY_FSTAB := $(LOCAL_PATH)/rootdir/etc/fstab.mt8173

# Include
TARGET_SPECIFIC_HEADER_PATH += $(LOCAL_PATH)/include

TARGET_SYSTEM_PROP := $(LOCAL_PATH)/system.prop

# SELinux
SELINUX_IGNORE_NEVERALLOWS := true
BOARD_SEPOLICY_DIRS += \
        $(LOCAL_PATH)/sepolicy-mtk/basic/non_plat \
        $(LOCAL_PATH)/sepolicy-mtk/bsp/non_plat \
        $(LOCAL_PATH)/sepolicy-mt8173/basic \
        $(LOCAL_PATH)/sepolicy-mt8173/bsp \
        $(LOCAL_PATH)/sepolicy

BOARD_PLAT_PUBLIC_SEPOLICY_DIR += \
        $(LOCAL_PATH)/sepolicy-mtk/basic/plat_public \
        $(LOCAL_PATH)/sepolicy-mtk/bsp/plat_public

BOARD_PLAT_PRIVATE_SEPOLICY_DIR += \
        $(LOCAL_PATH)/sepolicy-mtk/basic/plat_private \
        $(LOCAL_PATH)/sepolicy-mtk/bsp/plat_private

# Seccomp filter
BOARD_SECCOMP_POLICY := $(LOCAL_PATH)/seccomp

#Disable block system OTA package
BLOCK_BASED_OTA := false

# Treble
BOARD_VNDK_VERSION := current
BOARD_VNDK_RUNTIME_DISABLE := true

# Wifi
BOARD_WLAN_DEVICE := MediaTek
WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_mt66xx
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WLAN_DEVICE := bcmdhd
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_bcmdhd
WIFI_DRIVER_FW_PATH_PARAM := "/sys/module/bcmdhd/parameters/firmware_path"
WIFI_DRIVER_FW_PATH_STA := "/system/etc/firmware/fw_bcmdhd.bin"
WIFI_DRIVER_FW_PATH_AP := "/system/etc/firmware/fw_bcmdhd_apsta.bin"
WIFI_DRIVER_FW_PATH_P2P := "/system/etc/firmware/fw_bcmdhd.bin"

WIFI_DRIVER_FW_PATH_PARAM := /dev/wmtWifi
WIFI_DRIVER_FW_PATH_STA:=STA
WIFI_DRIVER_FW_PATH_AP:=AP
WIFI_DRIVER_FW_PATH_P2P:=P2P
WIFI_DRIVER_STATE_CTRL_PARAM := /dev/wmtWifi
WIFI_DRIVER_STATE_ON := 1
WIFI_DRIVER_STATE_OFF := 0

# Inherit from the proprietary version
-include vendor/xiaomi/cappu/BoardConfigVendor.mk
