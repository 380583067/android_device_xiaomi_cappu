# cappu Android 12 兼容组件

* `libpixelflinger`：导入 LineageOS/android_system_core 的 lineage-15.1 原始实现。
  MTK `libccap.so` 仍依赖其真实渲染 API。设备内编译 vendor 双架构库，保留原 NOTICE。
* `llvm`：参考 arttttt/android_device_xiaomi_mocha lineage-19.1 的
  `shims/llvm_accessors.cpp`；转发至 Android 12 保留的 LLVM 3.8。
  不包含 NVIDIA EGL、HWC、内核或 TOS 改动。
