# Copyright (C) 2018 The LineageOS Project

DEVICE_PATH := device/xiaomi/cappu

# Android 12 UsbDeviceManager restores the per-user unlocked USB functions from
# /data/system_de/0/UsbDeviceManagerPrefs.xml. Install a first-boot init hook
# to seed MTP+ADB only when that preference file does not exist yet; existing
# user-selected USB modes are therefore retained across upgrades and reboots.
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/rootdir/etc/init/init.cappu-usb-default.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.cappu-usb-default.rc \
    $(DEVICE_PATH)/rootdir/etc/init/cappu-usb-default.sh:$(TARGET_COPY_OUT_VENDOR)/bin/cappu-usb-default.sh

# Inherit from those products. Most specific first.
# cappu 原机是 Android 7（API 24），不是 Android 8.1 首发设备。
# 保留 vendor 的 FCM 2 合约，同时按真实首发 API 选择平台的旧设备支持模块。
PRODUCT_SHIPPING_API_LEVEL := 24
PRODUCT_ENFORCE_VINTF_MANIFEST := true
PRODUCT_ENFORCE_VINTF_MANIFEST_OVERRIDE := true
PRODUCT_PACKAGES += $(PRODUCT_PACKAGES_SHIPPING_API_LEVEL_29)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)

DEVICE_PACKAGE_OVERLAYS += \
    $(LOCAL_PATH)/overlay \
    $(LOCAL_PATH)/overlay-lineage

# cappu 所在网络环境下实测 Google 默认 HTTPS 探测超时，会导致 NetworkMonitor
# 将 Wi-Fi 标记为 PARTIAL_CONNECTIVITY，并让 Wi-Fi 自动加入跳过该保存网络。
# 使用设备专属的 NetworkStack RRO 调整探测地址，保留 Android 原生门户检测。
PRODUCT_PACKAGES += CappuNetworkStackOverlay

# Device uses high-density artwork where available
PRODUCT_CHARACTERISTICS := tablet
PRODUCT_AAPT_CONFIG := normal large xlarge
PRODUCT_AAPT_PREF_CONFIG := xhdpi

PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.heapstartsize=16m \
    dalvik.vm.heapgrowthlimit=256m \
    dalvik.vm.heapsize=512m \
    dalvik.vm.heaptargetutilization=0.75 \
    dalvik.vm.heapminfree=4m \
    dalvik.vm.heapmaxfree=8m

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.mtkrc.path=/vendor/etc/init/hw/ \
    ro.mount.fs=EXT4 \
    ro.oem_unlock_supported=1 \
    camera.disable_zsl_mode=1

# cappu 仍使用 Linux 3.18.123；该内核没有 Android 12 bpfloader 所需的
# bpf() map/program 支持。若保留平台默认值，bpfloader 会加载 tethering
# BPF 对象失败，并由系统自带的 reboot_on_failure 触发无限重启。
# Android 12 的 bpfloader 会在此属性为 false 时跳过 BPF 对象加载，仍设置
# bpf.progs_loaded=1 后正常退出，让 netd 不会无限等待加载完成。
# 代价是依赖 eBPF 的流量统计、带宽规则和 tethering offload 功能不可用或受限；
# 这是旧内核设备启动所需的兼容退化，后续升级到支持 Android BPF 的内核后应移除。
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.kernel.ebpf.supported=false

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.camera.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.xml \
    frameworks/native/data/etc/android.hardware.camera.autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.faketouch.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.faketouch.xml \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.distinct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.distinct.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_0_3.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml \
    frameworks/native/data/etc/android.software.verified_boot.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.verified_boot.xml \
    frameworks/native/data/etc/handheld_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/handheld_core_hardware.xml

# Init
PRODUCT_PACKAGES += \
    fstab.enableswap \
    fstab.mt8173 \
    init.connectivity.rc \
    init.mt8173.rc \
    init.mt8173.usb.rc \
    init.recovery.mt8173.rc \
    init.sensor_1_0.rc \
    ueventd.mt8173.rc

# Camera
PRODUCT_PACKAGES += \
    Snap

# HIDL
PRODUCT_PACKAGES += \
    android.hidl.base@1.0 \
    android.hidl.manager@1.0

# Light
PRODUCT_PACKAGES += \
    lights.mt8173 \
    android.hardware.light@2.0-impl-mediatek \
    android.hardware.light@2.0-service-mediatek

# Audio
PRODUCT_PACKAGES += \
    audio.r_submix.mt8173 \
    audio.usb.default \
    audio_policy.stub \
    libaudioroute \
    libtinyalsa \
    libtinycompress \
    libalsautils

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/audio/mixer_paths.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths.xml \
    $(LOCAL_PATH)/audio/AudioParamOptions.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_param/AudioParamOptions.xml \
    $(LOCAL_PATH)/audio/audio_effects.conf:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.conf \
    $(LOCAL_PATH)/audio/audio_em.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_em.xml \
    $(LOCAL_PATH)/audio/audio_policy.conf:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy.conf \
    $(LOCAL_PATH)/audio/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml

PRODUCT_COPY_FILES += \
    $(TOPDIR)frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_audio_policy_configuration.xml \
    $(TOPDIR)frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    $(TOPDIR)frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    $(TOPDIR)frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    $(TOPDIR)frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml

# Use the Android 12 AOSP Audio HAL 2.0 passthrough adapter for the legacy
# MT8173 C audio module. The shipped MTK HIDL adapter aborts in
# Device::openOutputStream on this platform build; the 2.0 interface remains
# the one declared by cappu's vendor service and audio policy.
PRODUCT_PACKAGES += \
    android.hardware.audio@2.0-impl \
    android.hardware.audio.effect@2.0-impl

# Bluetooth
PRODUCT_PACKAGES += \
    android.hardware.bluetooth@1.0-service \
    android.hardware.bluetooth@1.0-impl \
    libbt-vendor \
    audio.a2dp.default

# Media
# The legacy MTK OMX core dlopens libmp4enc_sa.ca7.so, which needs the 32-bit
# libcompiler_rt runtime. Its copy in the VNDK APEX is hidden from this vendor
# process namespace, so install the same-build runtime in /vendor/lib locally.
PRODUCT_PACKAGES += cappu_vendor_libcompiler_rt

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml \
    $(LOCAL_PATH)/configs/media_codecs_performance.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml \
    $(LOCAL_PATH)/configs/media_codecs_mediatek_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_mediatek_audio.xml \
    $(LOCAL_PATH)/configs/media_codecs_mediatek_video.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_mediatek_video.xml \
    $(LOCAL_PATH)/configs/media_profiles.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles.xml

PRODUCT_COPY_FILES += \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_telephony.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video_le.xml

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/seccomp_policy/mediacodec.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy \
    $(LOCAL_PATH)/seccomp_policy/mediaextractor.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediaextractor.policy

PRODUCT_PACKAGES += \
    libnbaio_mono

# Net
PRODUCT_PACKAGES += \
    netutils-wrapper-1.0

PRODUCT_PACKAGES += \
    libion \
    libcap

# DRM
PRODUCT_PACKAGES += \
    libdrm \
    libmockdrmcryptoplugin \
    android.hardware.drm@1.0-impl \
    android.hardware.drm@1.0-service

# Display
PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.mapper@2.0-impl \
    android.hardware.graphics.composer@2.1-service \
    android.hardware.memtrack@1.0-impl \
    android.hardware.memtrack@1.0-service \

# RenderScript HAL
PRODUCT_PACKAGES += \
    android.hardware.renderscript@1.0-impl

# cappu Android 12 传感器：ISensors 1.0 包装本地 sensors.mt8173。
# 不再请求已从平台删除的 libsensorndkbridge。
# Sensor
PRODUCT_PACKAGES += \
    sensors.mt8173 \
    android.hardware.sensors@1.0-impl-mediatek \
    android.hardware.sensors@1.0-service-mediatek

# cappu Android 12：由 BoardConfig.mk 的 BOARD_VNDK_VERSION 选择并安装当前
# VNDK APEX；linkerconfig 据此生成 system 可见的 sphal 命名空间及 VNDK-SP 链接。
# 这是加载 Android 7 MTK EGL SP-HAL 的 Treble 正规路径，不再手工复制旧 vndk-sp。

# cappu 的 Android 7 MTK 图形 HAL 还直接依赖 libgui.so 等非稳定系统库。
# 只给 composer 服务增加 system/lib64 的 linker 搜索路径；不要全局设置
# LD_CONFIG_FILE，否则会覆盖 Android 12 linkerconfig 并破坏 APEX namespace。
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/rootdir/etc/init/zz-cappu-hwcomposer-compat.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/zz-cappu-hwcomposer-compat.rc \
    $(DEVICE_PATH)/rootdir/etc/init/zz-cappu-vendor-hal-compat.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/zz-cappu-vendor-hal-compat.rc

# cappu Android 12 HIDL supplicant 在 /data/vendor/wifi/wpa 缺少配置时，
# 会从 /vendor/etc/wifi/wpa_supplicant.conf 初始化 STA/P2P 配置。
# 这个 legacy device.mk 未包含源码树里默认被注释掉的配置模块，必须由设备树提供模板。
# Wifi
# Android 12 统一由 HIDL ISupplicant 管理 STA/P2P；让 wpa_supplicant 模块安装
# 自带的 1.4 HIDL service rc/VINTF fragment。旧版 p2p_supplicant 与
# wpa_supplicant service 定义在 init.connectivity.rc 中移除，避免重复注册。
WIFI_HIDL_UNIFIED_SUPPLICANT_SERVICE_RC_ENTRY := true
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/wifi/p2p_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant_overlay.conf \
    $(LOCAL_PATH)/wifi/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf

PRODUCT_PACKAGES += \
    libwpa_client \
    libwifi-hal-bcm \
    hostapd \
    hostapd_cli \
    wpa_supplicant.conf \
    wpa_supplicant \
    android.hardware.wifi@1.0-service

# Keymaster
PRODUCT_PACKAGES += \
    android.hardware.keymaster@3.0-impl \
    android.hardware.keymaster@3.0-service

# cappu Android 12：用平台维护的软件 Gatekeeper 服务替代树内旧实现。
# 服务自带 VINTF fragment，因此主 manifest 不重复声明该实例。
# Gatekeeper
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper@1.0-service.software

$(call inherit-product-if-exists, vendor/xiaomi/cappu/cappu-vendor.mk)

# cappu Android 12 启动链：system.img 由平台生成 system-as-root 布局，
# boot 仍带传统 ramdisk；第一阶段 init 从 ramdisk fstab 挂载 system 和 cust/vendor，
# 再切换根目录，之后才会加载 /vendor/etc/init/hw/init.mt8173.rc。
# 不能等 vendor 的 on fs 再挂载 system/vendor，否则 init 自身尚不可执行。
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/rootdir/etc/fstab.mt8173:$(TARGET_COPY_OUT_RAMDISK)/fstab.mt8173

# cappu Android 12 eng 默认使用 USB MTP+ADB，避免 adb-only 属性关闭文件传输接口；
# init.mt8173.usb.rc 会将它映射为 MTP 与 FunctionFS ADB。TCP 5555 保留作 USB 异常时的调试后备。
# 只影响 eng 产品；调试包使用无授权 ADB，其他构建类型不继承此配置。
ifeq ($(TARGET_BUILD_VARIANT),eng)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.adb.secure=0 \
    persist.sys.usb.config=mtp,adb \
    service.adb.tcp.port=5555
endif

# Healthd
PRODUCT_PACKAGES += \
    android.hardware.health@2.1-impl \
    android.hardware.health@2.1-impl.recovery \
    android.hardware.health@2.1-service

# cappu Android 12 FCM：平台只打包 FCM 3+；本设备的 MTK vendor 仍为 FCM 2。
# 追加设备内保存的官方旧矩阵，保持 HAL 与 3.18 内核要求都可检查。
PRODUCT_PACKAGES += cappu_framework_compatibility_matrix.2.xml
