/*
 * Android 8 MTK decoder ABI bridge for Bionic's private __pthread_gettid.
 *
 * Bionic's compatibility implementation has the same pthread_t-to-tid
 * behavior but is no longer present in the public libc link interface. Keep
 * this old import device-local and forward it to the public API introduced in
 * Android 5; blob-fixups removes only this symbol's stale LIBC_PRIVATE version
 * requirement so the runtime linker resolves it from this vendor shim.
 */
#include <pthread.h>
#include <sys/types.h>

extern "C" __attribute__((visibility("default")))
pid_t cappu_legacy_pthread_gettid(pthread_t thread)
        __asm__("__pthread_gettid");

extern "C" __attribute__((visibility("default")))
pid_t cappu_legacy_pthread_gettid(pthread_t thread) {
    return pthread_gettid_np(thread);
}
