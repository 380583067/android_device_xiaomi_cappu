# Android 8 MTK graphics ABI bridges, built for both vendor process bitnesses.
LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := libcappu_graphics_compat
LOCAL_MODULE_TAGS := optional
LOCAL_VENDOR_MODULE := true
LOCAL_MULTILIB := both
LOCAL_SRC_FILES := \
    fence_compat.cpp \
    graphic_buffer_compat.cpp \
    graphics_mapper_compat.cpp
LOCAL_C_INCLUDES += \
    frameworks/native/libs/ui/include \
    system/libbase/include \
    system/core/libutils/include
LOCAL_SHARED_LIBRARIES := libui libc++
include $(BUILD_SHARED_LIBRARY)
