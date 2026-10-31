# Device-local LineageOS 19.1 compatibility for legacy MTK HIDL camera blobs.
LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := libcappu_hidl_compat
LOCAL_MODULE_TAGS := optional
LOCAL_VENDOR_MODULE := true
LOCAL_MULTILIB := both
LOCAL_SRC_FILES := debuginfo_compat.cpp
LOCAL_SHARED_LIBRARIES := libhidlbase libc++
include $(BUILD_SHARED_LIBRARY)
