# cappu Android 12 HIDL：transport 和 hwbinder 的实现已合并到 libhidlbase。
# 本地服务只链接 libhidlbase，避免依赖平台已废弃的空壳库。
LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := android.hardware.light@2.0-impl-mediatek
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := hw
LOCAL_SRC_FILES := \
    Light.cpp \

LOCAL_SHARED_LIBRARIES := \
    libhidlbase \
    libutils \
    liblog \
    libcutils \
    libhardware \
    libbase \
    libcutils \
    android.hardware.light@2.0 \

include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE_RELATIVE_PATH := hw
LOCAL_MODULE := android.hardware.light@2.0-service-mediatek
LOCAL_INIT_RC := android.hardware.light@2.0-service-mediatek.rc
LOCAL_PROPRIETARY_MODULE := true
LOCAL_SRC_FILES := \
    service.cpp \

LOCAL_SHARED_LIBRARIES := \
    liblog \
    libcutils \
    libdl \
    libbase \
    libutils \
    libhardware_legacy \
    libhardware \

LOCAL_SHARED_LIBRARIES += \
    libhidlbase \
    android.hardware.light@2.0 \

include $(BUILD_EXECUTABLE)
