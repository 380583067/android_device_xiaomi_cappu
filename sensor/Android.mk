# cappu Android 12：传感器源码链接 vendor 的唯一 libksensor 模块；
# 模块名有 cappu_blob_ 前缀，安装文件名仍是 libksensor.so。
#Copyright Statement:
#
# This software/firmware and related documentation ("MediaTek Software") are
# protected under relevant copyright laws. The information contained herein
# is confidential and proprietary to MediaTek Inc. and/or its licensors.
# Without the prior written permission of MediaTek inc. and/or its licensors,
# any reproduction, modification, use or disclosure of MediaTek Software,
# and information contained herein, in whole or in part, shall be strictly prohibited.
# MediaTek Inc. (C) 2012. All rights reserved.
#
# BY OPENING THIS FILE, RECEIVER HEREBY UNEQUIVOCALLY ACKNOWLEDGES AND AGREES
# THAT THE SOFTWARE/FIRMWARE AND ITS DOCUMENTATIONS ("MEDIATEK SOFTWARE")
# RECEIVED FROM MEDIATEK AND/OR ITS REPRESENTATIVES ARE PROVIDED TO RECEIVER ON
# AN "AS-IS" BASIS ONLY. MEDIATEK EXPRESSLY DISCLAIMS ANY AND ALL WARRANTIES,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE OR NONINFRINGEMENT.
# NEITHER DOES MEDIATEK PROVIDE ANY WARRANTY WHATSOEVER WITH RESPECT TO THE
# SOFTWARE OF ANY THIRD PARTY WHICH MAY BE USED BY, INCORPORATED IN, OR
# SUPPLIED WITH THE MEDIATEK SOFTWARE, AND RECEIVER AGREES TO LOOK ONLY TO SUCH
# THIRD PARTY FOR ANY WARRANTY CLAIM RELATING THERETO. RECEIVER EXPRESSLY ACKNOWLEDGES
# THAT IT IS RECEIVER'S SOLE RESPONSIBILITY TO OBTAIN FROM ANY THIRD PARTY ALL PROPER LICENSES
# CONTAINED IN MEDIATEK SOFTWARE. MEDIATEK SHALL ALSO NOT BE RESPONSIBLE FOR ANY MEDIATEK
# SOFTWARE RELEASES MADE TO RECEIVER'S SPECIFICATION OR TO CONFORM TO A PARTICULAR
# STANDARD OR OPEN FORUM. RECEIVER'S SOLE AND EXCLUSIVE REMEDY AND MEDIATEK'S ENTIRE AND
# CUMULATIVE LIABILITY WITH RESPECT TO THE MEDIATEK SOFTWARE RELEASED HEREUNDER WILL BE,
# AT MEDIATEK'S OPTION, TO REVISE OR REPLACE THE MEDIATEK SOFTWARE AT ISSUE,
# OR REFUND ANY SOFTWARE LICENSE FEES OR SERVICE CHARGE PAID BY RECEIVER TO
# MEDIATEK FOR SUCH MEDIATEK SOFTWARE AT ISSUE.
#
# The following software/firmware and/or related documentation ("MediaTek Software")
# have been modified by MediaTek Inc. All revisions are subject to any receiver's
# applicable license agreements with MediaTek Inc.
#

LOCAL_PATH := $(call my-dir)

# HAL module implemenation, not prelinked and stored in
# hw/<SENSORS_HARDWARE_MODULE_ID>.<ro.hardware>.so
include $(CLEAR_VARS)
LOCAL_PRELINK_MODULE := false
#LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)/hw
LOCAL_MODULE_RELATIVE_PATH := hw
LOCAL_SHARED_LIBRARIES := \
    liblog \
    libcutils \
    libutils \
    libhardware \
    libstagefright_foundation \
    cappu_blob_lib_libksensor

LOCAL_HEADER_LIBRARIES := libutils_headers libhardware_headers
LOCAL_SRC_FILES := \
    SensorBase.cpp \
    sensors.cpp \
    SensorList.cpp \
    SensorContext.cpp \
    SensorManager.cpp \
    VendorInterface.cpp \
    MtkInterface.cpp \
    SensorCalibration.cpp \
    SensorEventReader.cpp \
    file.cpp \
    JSONObject.cpp \
    SensorSaved.cpp \
    DirectChannelManager.cpp \
    DirectChannel.cpp \
    Acceleration.cpp \
    Magnetic.cpp \
    Gyroscope.cpp \
    AmbienteLight.cpp \
    Proximity.cpp \
    Pressure.cpp \
    StepCounter.cpp \
    Activity.cpp \
    Pedometer.cpp \
    Humidity.cpp \
    Situation.cpp \
    Fusion.cpp \
    Biometric.cpp \
    WakeUpSet.cpp


LOCAL_C_INCLUDES+= \
        $(TOP)/device/xiaomi/cappu/include \
        $(TOP)/frameworks/av/media/libstagefright/include \
        $(LOCAL_PATH)/include

LOCAL_CFLAGS += -DCUSTOM_KERNEL_ALS
LOCAL_CFLAGS += -DCUSTOM_KERNEL_ACCELEROMETER
LOCAL_CFLAGS += -DCUSTOM_KERNEL_GYROSCOPE
LOCAL_CFLAGS += -DCUSTOM_KERNEL_MAGNETOMETER

LOCAL_MODULE := sensors.$(TARGET_BOARD_PLATFORM)
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_OWNER := mtk
LOCAL_MODULE_TAGS := optional
include $(BUILD_SHARED_LIBRARY)
