/*
 * Device-local Android 12 compatibility for the Android 8 MTK video encoder.
 *
 * libMtkOmxVenc.so still imports android::Fence::~Fence() (the ARM32 Itanium
 * ABI D1 entry point). Android 12 made Fence's destructor inline/defaulted,
 * so libui no longer exports that old dynamic symbol. Keep the encoder's real
 * destruction behavior by closing the fd owned by Fence's base::unique_fd;
 * LightRefBase's destructor is empty and Flattenable has no instance state.
 * Export the old mangled entry point from this shim so ELF checks and the
 * runtime linker both resolve it without allowing other missing symbols.
 */
#include <ui/Fence.h>

#include <unistd.h>

extern "C" __attribute__((visibility("default")))
void cappu_legacy_fence_d1(android::Fence* fence)
        __asm__("_ZN7android5FenceD1Ev");

extern "C" __attribute__((visibility("default")))
void cappu_legacy_fence_d1(android::Fence* fence) {
    if (fence == nullptr) {
        return;
    }

    const int fd = fence->get();
    if (fd >= 0) {
        // Fence's Android 12 member destructor performs this close through
        // base::unique_fd; the object storage and reference count stay owned
        // by the caller's existing destruction path.
        (void)::close(fd);
    }
}
