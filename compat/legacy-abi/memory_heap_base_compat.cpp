/*
 * Bridge the Android 8 MemoryHeapBase constructor used by MTK camera blobs.
 * Android 12 changed only its fourth parameter from uint32_t to off_t. Export
 * the exact old ARM/ARM64 mangled constructor entry and forward its zero-
 * extended offset to the current public libbinder constructor.
 */
#include <binder/MemoryHeapBase.h>

#include <cstddef>
#include <cstdint>
#include <new>
#include <sys/types.h>

#if defined(__LP64__)
#define CAPPU_LEGACY_MEMORY_HEAP_BASE_CTOR "_ZN7android14MemoryHeapBaseC1Eimjj"
#else
#define CAPPU_LEGACY_MEMORY_HEAP_BASE_CTOR "_ZN7android14MemoryHeapBaseC1Eijjj"
#endif

extern "C" __attribute__((visibility("default")))
void cappu_legacy_memory_heap_base_ctor(android::MemoryHeapBase* storage,
        int fd, size_t size, uint32_t flags, uint32_t offset)
        __asm__(CAPPU_LEGACY_MEMORY_HEAP_BASE_CTOR);

extern "C" __attribute__((visibility("default")))
void cappu_legacy_memory_heap_base_ctor(android::MemoryHeapBase* storage,
        int fd, size_t size, uint32_t flags, uint32_t offset) {
    // The old offset was unsigned 32-bit, so preserve its value when widened.
    ::new (static_cast<void*>(storage)) android::MemoryHeapBase(
            fd, size, flags, static_cast<off_t>(offset));
}

#undef CAPPU_LEGACY_MEMORY_HEAP_BASE_CTOR
