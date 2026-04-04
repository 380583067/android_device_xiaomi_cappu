LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := ui/GraphicBuffer.cpp
LOCAL_SHARED_LIBRARIES := \
    libui \
    libgui \
    libutils \
    libcutils \
    libc++

LOCAL_MODULE := libshim_ui
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_PROPRIETARY_MODULE := true
LOCAL_ALLOW_UNDEFINED_SYMBOLS := true
LOCAL_LDFLAGS += -Wl,--export-dynamic
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := libshim_showlogo.cpp
LOCAL_MODULE := libshim_showlogo
LOCAL_SHARED_LIBRARIES := libgui
LOCAL_MODULE_TAGS := optional
#LOCAL_VENDOR_MODULE := true
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := camera.cpp
LOCAL_MODULE := libcamera_shim
LOCAL_MODULE_TAGS := optional
LOCAL_VENDOR_MODULE := true
include $(BUILD_SHARED_LIBRARY)
