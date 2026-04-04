#include <dlfcn.h>
#include <log/log.h>
#include <stdint.h>

// 定义函数指针类型，对应新版的 setLayer(int32_t)
using SetLayerFunc = void (*)(void* thiz, int32_t layer);

extern "C" {

    // ###########################################################
    // # 核心修复：直接导出缺失的旧版 mangled 符号
    // # 符号名：_ZN7android14SurfaceControl8setLayerEj
    // # 对应：android::SurfaceControl::setLayer(unsigned int)
    // ###########################################################
    void _ZN7android14SurfaceControl8setLayerEj(void* thiz, uint32_t layer) {
        ALOGD("libmtk_symbols: Shimmed _ZN7android14SurfaceControl8setLayerEj(%p, %u)", thiz, layer);

        static SetLayerFunc real_setLayer = nullptr;

        // 只在第一次调用时通过 dlsym 查找系统里的新版符号
        if (real_setLayer == nullptr) {
            // 打开 libgui.so
            void* handle = dlopen("libgui.so", RTLD_NOW);
            if (handle != nullptr) {
                // 查找新版符号：_ZN7android14SurfaceControl8setLayerEi
                real_setLayer = reinterpret_cast<SetLayerFunc>(
                    dlsym(handle, "_ZN7android14SurfaceControl8setLayerEi")
                );
                if (real_setLayer == nullptr) {
                    ALOGE("libmtk_symbols: Failed to find new setLayer symbol: %s", dlerror());
                }
            } else {
                ALOGE("libmtk_symbols: Failed to open libgui.so: %s", dlerror());
            }
        }

        // 如果找到了新版符号，就调用它
        if (real_setLayer != nullptr && thiz != nullptr) {
            ALOGD("libmtk_symbols: Calling new setLayer(%p, %d)", thiz, static_cast<int32_t>(layer));
            real_setLayer(thiz, static_cast<int32_t>(layer));
        } else {
            ALOGE("libmtk_symbols: real_setLayer or thiz is null, cannot call!");
        }
    }

} // extern "C"


