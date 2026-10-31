# Keep the old MTK OMX dependency local to cappu: stage the exact 32-bit
# libcompiler_rt built into this product's VNDK APEX under /vendor/lib so the
# vendor OMX process can resolve its DT_NEEDED entry without changing global
# linker namespaces or carrying a stale binary blob in the device repository.
include $(CLEAR_VARS)
LOCAL_MODULE := cappu_vendor_libcompiler_rt
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_TAGS := optional
LOCAL_VENDOR_MODULE := true
LOCAL_MULTILIB := 32
LOCAL_MODULE_SUFFIX := .so
LOCAL_INSTALLED_MODULE_STEM := libcompiler_rt.so
LOCAL_PREBUILT_MODULE_FILE := $(TARGET_OUT)/apex/com.android.vndk.current/lib/libcompiler_rt.so
LOCAL_CHECK_ELF_FILES := true
LOCAL_STRIP_MODULE := false
include $(BUILD_PREBUILT)
