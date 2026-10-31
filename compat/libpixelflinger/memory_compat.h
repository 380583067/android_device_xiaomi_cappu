/*
 * Device-local Android 12 compatibility helpers for the Android 8
 * pixelflinger sources. The old cutils android_memset16/32 APIs were removed;
 * their third argument was a byte count, so these replacements preserve that
 * contract and fill only complete elements used by the legacy call sites.
 */
#pragma once

#include <stddef.h>
#include <stdint.h>

static inline void pixelflinger_memset16(uint16_t* dst, uint16_t value,
        size_t bytes)
{
    for (size_t i = 0; i < bytes / sizeof(*dst); ++i) {
        dst[i] = value;
    }
}

static inline void pixelflinger_memset32(uint32_t* dst, uint32_t value,
        size_t bytes)
{
    for (size_t i = 0; i < bytes / sizeof(*dst); ++i) {
        dst[i] = value;
    }
}
