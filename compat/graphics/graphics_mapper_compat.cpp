/*
 * Android 8 MTK decoder ABI bridge for GraphicBufferMapper::lock.
 *
 * Android 12 added the optional output-stride arguments to this method, which
 * changes its mangled symbol even though the original operation remains. The
 * decoder only requests the mapped address, so forward its old entry point to
 * the current libui overload with both optional outputs omitted.
 */
#include <ui/GraphicBufferMapper.h>

extern "C" __attribute__((visibility("default")))
android::status_t cappu_legacy_graphic_buffer_mapper_lock(
        android::GraphicBufferMapper* mapper, buffer_handle_t handle,
        uint32_t usage, const android::Rect* bounds, void** vaddr)
        __asm__("_ZN7android19GraphicBufferMapper4lockEPK13native_handlejRKNS_4RectEPPv");

extern "C" __attribute__((visibility("default")))
android::status_t cappu_legacy_graphic_buffer_mapper_lock(
        android::GraphicBufferMapper* mapper, buffer_handle_t handle,
        uint32_t usage, const android::Rect* bounds, void** vaddr) {
    if (mapper == nullptr || bounds == nullptr || vaddr == nullptr) {
        return android::BAD_VALUE;
    }

    return mapper->lock(handle, usage, *bounds, vaddr, nullptr, nullptr);
}
