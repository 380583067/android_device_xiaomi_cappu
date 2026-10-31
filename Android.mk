# Copyright (C) 2018 The LineageOS Project

LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_DEVICE),cappu)

CAPPU_DEVICE_ROOT := $(LOCAL_PATH)
include $(call all-makefiles-under,$(LOCAL_PATH))
# libccap's old MTK vendor ABI imports the real pixelflinger implementation;
# explicitly load its nested Android.mk because the device scan above stops
# before compat/libpixelflinger/Android.mk.
LOCAL_PATH := $(CAPPU_DEVICE_ROOT)
include $(CAPPU_DEVICE_ROOT)/compat/libpixelflinger/Android.mk
# Keep Android 8 MediaTek codec ABI support local to cappu; this 32-bit bridge
# exports the ARM EABI, xlog, and pthread helpers required by stock codecs.
LOCAL_PATH := $(CAPPU_DEVICE_ROOT)
include $(CAPPU_DEVICE_ROOT)/compat/legacy-abi/Android.mk
# GraphicBuffer/Fence signatures changed across Android releases. Build these
# real forwarding wrappers for both vendor ABIs and link only the blobs that
# still import the old entry points.
LOCAL_PATH := $(CAPPU_DEVICE_ROOT)
include $(CAPPU_DEVICE_ROOT)/compat/graphics/Android.mk
# The old MTK camera provider imports a generated HIDL DebugInfo formatter that
# is inline-only in Android 12; export its compatibility bridge from a small
# vendor library for both ARM32 and ARM64 blobs.
LOCAL_PATH := $(CAPPU_DEVICE_ROOT)
include $(CAPPU_DEVICE_ROOT)/compat/hidl/Android.mk
# all-makefiles-under scans only one directory level. Explicitly load the nested
# LLVM ABI bridge so rs2spir's legacy libLLVM.so dependency resolves to a vendor library.
LOCAL_PATH := $(CAPPU_DEVICE_ROOT)
include $(CAPPU_DEVICE_ROOT)/compat/llvm/Android.mk
# The stock MT8173 gralloc imports sw_sync functions that Android 12 keeps out
# of the generic libsync vendor ABI. Provide a cappu-only vendor shim instead
# of widening the platform VNDK symbol map for every device.
LOCAL_PATH := $(CAPPU_DEVICE_ROOT)
include $(CAPPU_DEVICE_ROOT)/compat/sw-sync/Android.mk
LOCAL_PATH := $(CAPPU_DEVICE_ROOT)

include $(CLEAR_VARS)

NVDATA_MOUNT_POINT := $(TARGET_OUT_VENDOR)/nvdata
PROTECT_F_MOUNT_POINT  := $(TARGET_OUT_VENDOR)/protect_f
PROTECT_S_MOUNT_POINT := $(TARGET_OUT_VENDOR)/protect_s

$(NVDATA_MOUNT_POINT):
	@echo "Creating $(NVDATA_MOUNT_POINT)"
	@mkdir -p $(NVDATA_MOUNT_POINT)

$(PROTECT_F_MOUNT_POINT):
	@echo "Creating $(PROTECT_F_MOUNT_POINT)"
	@mkdir -p $(PROTECT_F_MOUNT_POINT)

$(PROTECT_S_MOUNT_POINT):
	@echo "Creating $(PROTECT_S_MOUNT_POINT)"
	@mkdir -p $(PROTECT_S_MOUNT_POINT)

ALL_DEFAULT_INSTALLED_MODULES += \
	$(NVDATA_MOUNT_POINT) \
	$(PROTECT_F_MOUNT_POINT) $(PROTECT_S_MOUNT_POINT) \

# cappu Android 12：KERNEL_OBJ 目录及内核头依赖由 vendor/lineage 的 kernel.mk
# 统一创建；旧设备树再次为该目标添加 recipe 会被 Kati 拒绝。

endif
