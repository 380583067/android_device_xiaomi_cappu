# Device-local implementation for the pre-Treble MT8173 gralloc blob.
LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := libcappu_sw_sync_compat
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_OWNER := Xiaomi
LOCAL_VENDOR_MODULE := true
LOCAL_MULTILIB := both
LOCAL_SRC_FILES := sw_sync_compat.c
LOCAL_CFLAGS := -Wall -Werror
include $(BUILD_SHARED_LIBRARY)

LOCAL_PATH := $(CAPPU_DEVICE_ROOT)
