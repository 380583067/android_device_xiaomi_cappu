#include <ui/GraphicBufferMapper.h>
#include <ui/Rect.h>
#include <string>

__attribute__((visibility("default")))
extern "C" {
    void _ZN7android19GraphicBufferMapper4lockEPK13native_handleiRKNS_4RectEPPv(
        buffer_handle_t handle,
        int usage,
        const android::Rect& bounds,
        void** vaddr) {
        android::GraphicBufferMapper::get().lock(
            handle,
            static_cast<uint32_t>(usage),
            bounds,
            vaddr);
    }

    __attribute__((weak))
    void _ZN7android19GraphicBufferMapper4lockEPK13native_handlejRKNS_4RectEPPv(
        buffer_handle_t handle,
        uint32_t usage,
        const android::Rect& bounds,
        void** vaddr) {
        android::GraphicBufferMapper::get().lock(handle, usage, bounds, vaddr);
    }

    void _ZN7android19GraphicBufferMapper9lockYCbCrEPK13native_handleiRKNS_4RectEP13android_ycbcr(
        buffer_handle_t handle,
        int usage,
        const android::Rect& bounds,
        android_ycbcr* ycbcr) {
        android::GraphicBufferMapper::get().lockYCbCr(
            handle,
            static_cast<uint32_t>(usage),
            bounds,
            ycbcr);
    }

    __attribute__((weak))
    void _ZN7android19GraphicBufferMapper9lockYCbCrEPK13native_handlejRKNS_4RectEP13android_ycbcr(
        buffer_handle_t handle,
        uint32_t usage,
        const android::Rect& bounds,
        android_ycbcr* ycbcr) {
        android::GraphicBufferMapper::get().lockYCbCr(handle, usage, bounds, ycbcr);
    }

    __attribute__((weak))
    void _ZN7android13GraphicBufferC1EjjijNSt3__112basic_stringIcNS1_11char_traitsIcEENS1_9allocatorIcEEEE(
        void* pthis,
        uint32_t inWidth,
        uint32_t inHeight,
        int inFormat,
        uint32_t inUsage,
        std::string requestorName) {
        (void)pthis;
        (void)inWidth;
        (void)inHeight;
        (void)inFormat;
        (void)inUsage;
        (void)requestorName;
    }

    void _ZN7android13GraphicBufferC1Ejjij(
        void* pthis,
        uint32_t inWidth,
        uint32_t inHeight,
        int inFormat,
        uint32_t inUsage) {
        _ZN7android13GraphicBufferC1EjjijNSt3__112basic_stringIcNS1_11char_traitsIcEENS1_9allocatorIcEEEE(
            pthis, inWidth, inHeight, inFormat, inUsage, "<Unknown>");
    }
}
