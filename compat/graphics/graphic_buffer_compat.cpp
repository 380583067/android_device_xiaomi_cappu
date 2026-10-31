/*
 * Android 8 MTK camera ABI bridge for GraphicBuffer::lock(uint32_t, void**).
 *
 * Android 12 adds optional stride and pixel-size outputs to the exported
 * overload. The camera client does not request those values, so preserve the
 * old mangled entry point and forward to the current overload with null output
 * pointers. This keeps the existing buffer mapper and gralloc behavior intact.
 */
#include <ui/GraphicBuffer.h>

extern "C" __attribute__((visibility("default")))
android::status_t cappu_legacy_graphic_buffer_lock(
        android::GraphicBuffer* buffer, uint32_t usage, void** vaddr)
        __asm__("_ZN7android13GraphicBuffer4lockEjPPv");

extern "C" __attribute__((visibility("default")))
android::status_t cappu_legacy_graphic_buffer_lock(
        android::GraphicBuffer* buffer, uint32_t usage, void** vaddr) {
    if (buffer == nullptr || vaddr == nullptr) {
        return android::BAD_VALUE;
    }

    return buffer->lock(usage, vaddr, nullptr, nullptr);
}
