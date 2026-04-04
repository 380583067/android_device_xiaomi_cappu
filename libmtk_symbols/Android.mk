LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
    mtk_xlog.cpp \
    mtk_gui.cpp \
    mtk_ui.cpp \
    mtk_audio.cpp \
    mtk_omx.cpp

LOCAL_SRC_FILES_64 := mtk_parcel.cpp

LOCAL_SHARED_LIBRARIES := \
    libbinder \
    liblog \
    libdl \
    libgui \
    libui \
    libc++

LOCAL_MODULE := libmtk_symbols
LOCAL_MODULE_TAGS := optional
LOCAL_VENDOR_MODULE := true
LOCAL_PROPRIETARY_MODULE := true
LOCAL_ALLOW_UNDEFINED_SYMBOLS := true

include $(BUILD_SHARED_LIBRARY)
