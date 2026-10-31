# cappu Android 12：MTK libccap 仍使用完整 libpixelflinger API，平台已移除此库。
# 从 LineageOS system/core lineage-15.1 导入原实现，保留原许可，仅供本设备 vendor。
# 不使用空壳绕过符号错误，也不恢复平台全局模块或旧测试程序。
LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

#
# C/C++ and ARMv5 objects
#

include $(CLEAR_VARS)
PIXELFLINGER_SRC_FILES:= \
	codeflinger/ARMAssemblerInterface.cpp \
	codeflinger/ARMAssemblerProxy.cpp \
	codeflinger/CodeCache.cpp \
	codeflinger/GGLAssembler.cpp \
	codeflinger/load_store.cpp \
	codeflinger/blending.cpp \
	codeflinger/texturing.cpp \
	format.cpp \
	clear.cpp \
	raster.cpp \
	buffer.cpp

PIXELFLINGER_CFLAGS := -fstrict-aliasing -fomit-frame-pointer

PIXELFLINGER_SRC_FILES_arm := \
	codeflinger/ARMAssembler.cpp \
	codeflinger/disassem.c \
	col32cb16blend.S \
	t32cb16blend.S \

ifeq ($(ARCH_ARM_HAVE_NEON),true)
PIXELFLINGER_SRC_FILES_arm += col32cb16blend_neon.S
PIXELFLINGER_CFLAGS_arm += -D__ARM_HAVE_NEON
endif

PIXELFLINGER_SRC_FILES_arm64 := \
	codeflinger/Arm64Assembler.cpp \
	codeflinger/Arm64Disassembler.cpp \
	arch-arm64/col32cb16blend.S \
	arch-arm64/t32cb16blend.S \

# Android 8 selected these five translation units with the legacy `.cpp.arm`
# suffix, which forced ARM instruction mode per file. Android 12 rejects that
# suffix, so compile the same files in a dedicated 32-bit static library whose
# LOCAL_ARM_MODE preserves the old code-generation requirement. Keep it out of
# the arm64 link and attach it only to libpixelflinger's ARM variant below.
PIXELFLINGER_ARM_MODE_SRC_FILES := \
	fixed.cpp \
	picker.cpp \
	pixelflinger.cpp \
	trap.cpp \
	scanline.cpp

include $(CLEAR_VARS)
LOCAL_MODULE := libpixelflinger_arm
LOCAL_VENDOR_MODULE := true
LOCAL_MULTILIB := 32
LOCAL_ARM_MODE := arm
LOCAL_SRC_FILES := $(PIXELFLINGER_ARM_MODE_SRC_FILES)
LOCAL_CFLAGS := $(PIXELFLINGER_CFLAGS)
# 这个 ARM 模式静态库单独编译旧版 pixelflinger 源文件，不会继承下方
# libpixelflinger 共享库依赖导出的头文件路径；显式加入 Android 12 的
# libutils 和 liblog 头文件目录，供 CodeCache.h、trap.cpp、scanline.cpp 使用。
LOCAL_C_INCLUDES += $(LOCAL_PATH)/include external/safe-iop/include \
		    system/core/libutils/include \
		    system/logging/liblog/include
include $(BUILD_STATIC_LIBRARY)

# BUILD_STATIC_LIBRARY consumes and leaves LOCAL_* module variables behind;
# reset them before defining the shared library so Kati registers it separately.
include $(CLEAR_VARS)

# cappu's Android 12 product is ARM64 with a 32-bit ARM secondary ABI.
# The original Android 8 pixelflinger makefile also carried MIPS branches, but
# current build/make marks ARCH_MIPS_REV6 obsolete and rejects evaluating it
# even when MIPS is not selected. Keep only the device's actual ARM sources.
#
# Shared library
#

LOCAL_MODULE:= libpixelflinger
LOCAL_VENDOR_MODULE := true
LOCAL_MULTILIB := both
LOCAL_SRC_FILES := $(PIXELFLINGER_SRC_FILES)
LOCAL_SRC_FILES_arm := $(PIXELFLINGER_SRC_FILES_arm)
LOCAL_SRC_FILES_arm64 := $(PIXELFLINGER_SRC_FILES_arm64)
# The 64-bit build compiles the former `.cpp.arm` files normally; ARM32 links
# the dedicated ARM-mode archive above, preventing duplicate definitions.
LOCAL_SRC_FILES_64 := $(PIXELFLINGER_ARM_MODE_SRC_FILES)
LOCAL_STATIC_LIBRARIES_32 := libpixelflinger_arm
LOCAL_CFLAGS := $(PIXELFLINGER_CFLAGS)
LOCAL_EXPORT_C_INCLUDE_DIRS := $(LOCAL_PATH)/include
LOCAL_C_INCLUDES += $(LOCAL_EXPORT_C_INCLUDE_DIRS) \
		    external/safe-iop/include
LOCAL_SHARED_LIBRARIES := libcutils liblog libutils

include $(BUILD_SHARED_LIBRARY)


