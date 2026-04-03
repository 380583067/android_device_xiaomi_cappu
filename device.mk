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

LOCAL_PATH := device/xiaomi/cappu

# ADB DEBUG
PRODUCT_PROPERTY_OVERRIDES += \
	persist.service.adb.enable=1 \
	persist.service.debuggable=1 \
	persist.sys.usb.config=mtp,adb \
	persist.sys.root_access=2 \
	ro.secure=0 \
	ro.adb.secure=0 \
	ro.debuggable=1

# API
PRODUCT_PACKAGES += $(PRODUCT_PACKAGES_SHIPPING_API_LEVEL_29)

# Vendor product configurations
$(call inherit-product, vendor/xiaomi/cappu/cappu-vendor.mk)

# Recovery allowed devices
TARGET_OTA_ASSERT_DEVICE := cappu

# Audio
PRODUCT_PACKAGES += \
    android.hardware.audio@2.0 \
    android.hardware.audio@2.0-impl \
    android.hardware.audio.effect@2.0-impl \
    audio_policy.default \
    audio.r_submix.default \
    audio.a2dp.default \
    audio.usb.default \
    libaudioroute \
    libtinyalsa \
    libtinycompress \
    libtinymix \
    libtinyxml \
    libalsautils \
    xaplay

PRODUCT_COPY_FILES += \
    frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration.xml:system/vendor/etc/a2dp_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:system/vendor/etc/audio_policy_volumes.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:system/vendor/etc/default_volume_tables.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:system/vendor/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:system/vendor/etc/usb_audio_policy_configuration.xml \
    $(LOCAL_PATH)/audio/mixer_paths.xml:system/vendor/etc/mixer_paths.xml \
    $(LOCAL_PATH)/audio/AudioParamOptions.xml:system/vendor/etc/audio_param/AudioParamOptions.xml \
    $(LOCAL_PATH)/audio/audio_effects.conf:system/vendor/etc/audio_effects.conf \
    $(LOCAL_PATH)/audio/audio_em.xml:system/vendor/etc/audio_em.xml \
    $(LOCAL_PATH)/audio/audio_policy.conf:system/vendor/etc/audio_policy.conf \
    $(LOCAL_PATH)/audio/audio_policy_configuration.xml:system/vendor/etc/audio_policy_configuration.xml

PRODUCT_COPY_FILES += \
    frameworks/av/services/audiopolicy/enginedefault/config/example/phone/audio_policy_engine_configuration.xml:system/vendor/etc/audio_policy_engine_configuration.xml \
    frameworks/av/services/audiopolicy/enginedefault/config/example/phone/audio_policy_engine_default_stream_volumes.xml:system/vendor/etc/audio_policy_engine_default_stream_volumes.xml \
    frameworks/av/services/audiopolicy/enginedefault/config/example/phone/audio_policy_engine_product_strategies.xml:system/vendor/etc/audio_policy_engine_product_strategies.xml \
    frameworks/av/services/audiopolicy/enginedefault/config/example/phone/audio_policy_engine_stream_volumes.xml:system/vendor/etc/audio_policy_engine_stream_volumes.xml


# Bluetooth
PRODUCT_PACKAGES += \
    libbt-vendor \
    android.hardware.bluetooth@1.0-impl \
    android.hardware.bluetooth@1.0-service


# Charger
PRODUCT_PACKAGES += \
    charger \
    charger_res_images

# Configstore HAL
PRODUCT_PACKAGES += \
    android.hardware.configstore@1.1-impl \
    android.hardware.configstore@1.1-service

# DRM HAL
PRODUCT_PACKAGES += \
    android.hardware.drm@1.0-service \
    android.hardware.drm@1.0-impl \

# DRM Shims
PRODUCT_COPY_FILES += \
    prebuilts/vndk/v27/arm/arch-arm-armv7-a-neon/shared/vndk-core/libprotobuf-cpp-lite.so:$(TARGET_COPY_OUT_VENDOR)/lib/libprotobuf-cpp-lite.so \
    prebuilts/vndk/v27/arm64/arch-arm-armv7-a-neon/shared/vndk-core/libprotobuf-cpp-lite.so:$(TARGET_COPY_OUT_VENDOR)/lib64/libprotobuf-cpp-lite.so

# Display
PRODUCT_PACKAGES += \
    libion

# FMRadio
#MTK_FM_SUPPORT := true
	
# Filesystem management tools
PRODUCT_PACKAGES += \
    e2fsck \
    fsck.f2fs \
    mkfs.f2fs \
    make_ext4fs

# exFAT
PRODUCT_PACKAGES += \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat

# Graphics
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := xxhdpi
PRODUCT_AAPT_PREBUILT_DPI := xxhdpi xhdpi 280dpi hdpi tvdpi mdpi ldpi
PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.composer@2.1-impl \
    android.hardware.graphics.mapper@2.0-impl

# EGL Shims
PRODUCT_COPY_FILES += \
    prebuilts/vndk/v28/arm/arch-arm-armv7-a-neon/shared/vndk-sp/libutilscallstack.so:$(TARGET_COPY_OUT_VENDOR)/lib/libutilscallstack.so \
    prebuilts/vndk/v28/arm64/arch-arm-armv8-a/shared/vndk-sp/libutilscallstack.so:$(TARGET_COPY_OUT_VENDOR)/lib64/libutilscallstack.so \
    $(LOCAL_PATH)/configs/ld.config.txt:$(TARGET_COPY_OUT_VENDOR)/etc/ld.config.txt

# NTFS
PRODUCT_PACKAGES += \
    fsck.ntfs \
    mkfs.ntfs \
    mount.ntfs

# Health
PRODUCT_PACKAGES += \
    android.hardware.health@2.0-impl \
    android.hardware.health@2.0-service

# HIDL
PRODUCT_PACKAGES += \
    android.hidl.base@1.0 \
    android.hidl.base@1.0_system \
    android.hidl.manager@1.0 \
    android.hidl.manager@1.0_system

# Binder
PRODUCT_PACKAGES += \
    libhidltransport \
    libhwbinder

# HIDL Manifest
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/manifest.xml:system/vendor/manifest.xml

# Keymaster
PRODUCT_PACKAGES += \
    android.hardware.keymaster@3.0-impl \
    android.hardware.keymaster@3.0-service

# Light
PRODUCT_PACKAGES += \
	android.hardware.light@2.0-impl

# Media_omx config
PRODUCT_PACKAGES += \
    android.hardware.media.omx@1.0-impl \
    android.hardware.media.omx@1.0-service

PRODUCT_COPY_FILES += \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:system/vendor/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:system/vendor/etc/media_codecs_google_telephony.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video_le.xml:system/vendor/etc/media_codecs_google_video_le.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:system/vendor/etc/media_codecs_google_video.xml \
    $(LOCAL_PATH)/media/media_codecs.xml:system/vendor/etc/media_codecs.xml \
    $(LOCAL_PATH)/media/media_profiles.xml:system/vendor/etc/media_profiles.xml \
    $(LOCAL_PATH)/media/media_codecs_ffmpeg.xml:system/vendor/etc/media_codecs_ffmpeg.xml \
    $(LOCAL_PATH)/media/media_codecs_mediatek_audio.xml:system/vendor/etc/media_codecs_mediatek_audio.xml \
    $(LOCAL_PATH)/media/media_codecs_mediatek_video.xml:system/vendor/etc/media_codecs_mediatek_video.xml \
    $(LOCAL_PATH)/media/media_codecs_performance.xml:system/vendor/etc/media_codecs_performance.xml

# OMX(SOFTWARE)
PRODUCT_PROPERTY_OVERRIDES += \
    debug.stagefright.c2-poolmask=0x80000 \
    debug.stagefright.ccodec=0

# Memtrack
PRODUCT_PACKAGES += \
    android.hardware.memtrack@1.0-impl

# Mediatek
PRODUCT_PACKAGES += \
    libstlport \

# Overlay
DEVICE_PACKAGE_OVERLAYS += \
    $(LOCAL_PATH)/overlay 

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.faketouch.xml:system/etc/permissions/android.hardware.faketouch.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-0.xml:system/etc/permissions/android.hardware.vulkan.level.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_0_3.xml:system/etc/permissions/android.hardware.vulkan.version.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml \
    frameworks/native/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml \
    frameworks/native/data/etc/android.hardware.camera.autofocus.xml:system/etc/permissions/android.hardware.camera.autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.manual_sensor.xml:system/etc/permissions/android.hardware.camera.manual_sensor.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:system/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:system/etc/permissions/android.hardware.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:system/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.distinct.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.distinct.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.xml:system/etc/permissions/android.hardware.touchscreen.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.ethernet.xml:system/etc/permissions/android.hardware.ethernet.xml \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:system/etc/permissions/android.hardware.audio.low_latency.xml \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml \


# Product
PRODUCT_CHARACTERISTICS := tablet

# Power
PRODUCT_PACKAGES += \
    android.hardware.power@1.0-impl \
    android.hardware.power@1.0-service \
    vendor.lineage.power@1.0

# Renderscript
PRODUCT_PACKAGES += \
    android.hardware.renderscript@1.0-impl

# Sensors
PRODUCT_PACKAGES += \
    android.hardware.sensors@1.0-impl

# Init
PRODUCT_PACKAGES += \
    fstab.mt8173 \
    init.aee.rc \
    init.common_svc.rc \
    init.connectivity.rc \
    init.fon.rc \
    init.modem.rc \
    init.mt8173.rc \
    init.mt8173.usb.rc \
    init.project.rc \
    init.protect.rc \
    ueventd.mt8173.rc

# Sensor Calibration
PRODUCT_PACKAGES += \
    libem_sensor_jni

# SECCOMP Configuration
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/seccomp/mediacodec-seccomp.policy:system/vendor/etc/seccomp_policy/mediacodec-seccomp.policy

# Thermal
PRODUCT_PACKAGES += \
    android.hardware.thermal@1.0-impl \
    android.hardware.thermal@1.0-service

# Trust
PRODUCT_PACKAGES += \
    vendor.lineage.trust@1.0-service

# USB HAL
PRODUCT_PACKAGES += \
    android.hardware.usb@1.0-service.basic

PRODUCT_PACKAGES += \
    librs_jni \
    com.android.future.usb.accessory

# Vibrator
PRODUCT_PACKAGES += \
	android.hardware.vibrator@1.0-service.lineage

# VNDK-SP:
PRODUCT_PACKAGES += \
    vndk-sp

# WiFi
PRODUCT_PACKAGES += \
    android.hardware.wifi@1.0-service \
    wificond \
    libwpa_client \
    hostapd \
    wpa_supplicant \
    wpa_supplicant.conf

