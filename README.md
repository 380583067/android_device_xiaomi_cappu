This Device Tree is used to build LineageOS 14.1. Currently, the camera and video decoding are not working, while other hardware functions properly.

Vendor:https://github.com/iiowoii3389/android_vendor_xiaomi_cappu

Kernel:https://github.com/iiowoii3389/android_kernel_xiaomi_cappu

Basic        | Spec Sheet
------------:|:------------------------
CPU          | Cortex-A72 & Cortex-A53 | Hexa-Core | MT8176
GPU          | PowerVR GX6250
Memory       | 4GB RAM
Shipped Android Version | 7.1
Storage      | 64GB
Battery      | 6600 mAh Li-Po
Display      | 7.9
Rear Camera  | 13.0 MP , Video
Front Camera | 5.0 MP

Fix (01-01 00:23:14.484   443   443 E HAL     : dlopen failed: cannot locate symbol "_ZN7android13GraphicBufferC1Ejjij" referenced by "/system/vendor/lib64/libui_ext.so"...)
```diff
--- GraphicBuffer_a.cpp	2026-02-26 14:26:07.580471302 +0800
+++ GraphicBuffer.cpp	2026-02-25 00:27:12.030013159 +0800
@@ -19,6 +19,7 @@
 #include <stdlib.h>
 #include <stdint.h>
 #include <sys/types.h>
+#include <new>
 
 #include <utils/Errors.h>
 #include <utils/Log.h>
@@ -415,4 +416,25 @@
 
 // ---------------------------------------------------------------------------
 
+extern "C" {
+    __attribute__((used, visibility("default")))
+    void _ZN7android13GraphicBufferC1Ejjij(
+            void* thisptr,
+            uint32_t width,
+            uint32_t height,
+            int32_t format,
+            uint32_t usage) {
+        new (thisptr) android::GraphicBuffer(
+            width,
+            height,
+            static_cast<android::PixelFormat>(format),
+            usage,
+            0,          
+            nullptr,    
+            false       
+        );
+    }
+}
+
 }; // namespace android