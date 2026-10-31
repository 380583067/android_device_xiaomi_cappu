# cappu Android 12：旧 MTK rs2spir 的 DT_NEEDED 仍是 libLLVM.so。
# 采用 mocha 的 LLVM 3.8 accessor 兼容做法，转发到平台 libLLVM_android，
# 只提供旧 ABI 的入口名，不引入 NVIDIA 驱动或私有实现。
LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := libLLVM
LOCAL_VENDOR_MODULE := true
LOCAL_MULTILIB := both
LOCAL_SRC_FILES := llvm_accessors.cpp
LOCAL_SHARED_LIBRARIES := libLLVM_android
LOCAL_CFLAGS := -D__STDC_LIMIT_MACROS -D__STDC_CONSTANT_MACROS -Wno-unused-parameter
include $(BUILD_SHARED_LIBRARY)
