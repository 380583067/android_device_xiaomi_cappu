# cappu Android 12 vendor ABI bridge for the remaining ARM32 MTK codecs.
# Reuse the checkout's compiler-rt implementations of the ARM EABI compare
# helpers and export them from one vendor library; the old blobs cannot resolve
# these hidden/compiler-only symbols from Android 12's public libcompiler_rt.
CAPPU_LEGACY_ABI_PATH := $(call my-dir)
CAPPU_COMPILER_RT_ARM_PATH := $(TOP)/external/compiler-rt/lib/builtins/arm

LOCAL_PATH := $(CAPPU_COMPILER_RT_ARM_PATH)
include $(CLEAR_VARS)
LOCAL_MODULE := libcappu_aeabi_compat
LOCAL_MODULE_TAGS := optional
LOCAL_VENDOR_MODULE := true
LOCAL_MULTILIB := 32
LOCAL_SRC_FILES := \
    aeabi_cdcmp.S \
    aeabi_cfcmp.S \
    aeabi_cdcmpeq_check_nan.c \
    aeabi_cfcmpeq_check_nan.c \
    aeabi_drsub.c
include $(BUILD_STATIC_LIBRARY)

# Export the EABI archive and device-local MTK compatibility entry points from
# one vendor DSO so only the legacy blobs that use them depend on this shim.
LOCAL_PATH := $(CAPPU_LEGACY_ABI_PATH)
include $(CLEAR_VARS)
LOCAL_MODULE := libcappu_legacy_abi
LOCAL_MODULE_TAGS := optional
LOCAL_VENDOR_MODULE := true
LOCAL_MULTILIB := 32
LOCAL_SRC_FILES := \
    pthread_compat.cpp \
    xlog_compat.cpp
LOCAL_WHOLE_STATIC_LIBRARIES := libcappu_aeabi_compat
# Android 12 marks libcompiler_rt.vendor as VNDK-private, so a vendor module
# must not link to it. The legacy AEABI entry points needed by cappu blobs are
# already compiled into libcappu_aeabi_compat and whole-archived above; keep
# only liblog here for the xlog compatibility wrapper.
LOCAL_SHARED_LIBRARIES := liblog
include $(BUILD_SHARED_LIBRARY)

LOCAL_PATH := $(CAPPU_LEGACY_ABI_PATH)

# Android 8 MTK camera blobs use MemoryHeapBase(fd, size, flags, uint32_t);
# Android 12 exports only the off_t overload, so ship a tiny vendor-side bridge.
include $(CLEAR_VARS)
LOCAL_MODULE := libcappu_memory_heap_base_compat
LOCAL_MODULE_TAGS := optional
LOCAL_VENDOR_MODULE := true
LOCAL_MULTILIB := both
LOCAL_SRC_FILES := memory_heap_base_compat.cpp
LOCAL_SHARED_LIBRARIES := libbinder libc++
include $(BUILD_SHARED_LIBRARY)
