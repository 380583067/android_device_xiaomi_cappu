/*
 * cappu MT8173 software-sync compatibility bridge.
 *
 * The stock 32-bit and 64-bit gralloc blobs import sw_sync_fence_create() and
 * sw_sync_timeline_inc(). Android 12 still contains the ioctl implementation
 * in libsync, but deliberately omits these test-oriented functions from the
 * generic vendor symbol map. Exporting them from a device-only vendor library
 * lets the old gralloc resolve its real runtime dependencies without changing
 * the platform-wide libsync/VNDK ABI. The ioctl numbers and request layout
 * below match system/core/libsync/sync.c and the MT8173 sw_sync kernel UAPI.
 */
#include <errno.h>
#include <fcntl.h>
#include <stdint.h>
#include <string.h>
#include <sys/ioctl.h>
#include <unistd.h>

#define SW_SYNC_IOC_MAGIC 'W'

struct sw_sync_create_fence_data {
    uint32_t value;
    char name[32];
    int32_t fence;
};

#define SW_SYNC_IOC_CREATE_FENCE \
    _IOWR(SW_SYNC_IOC_MAGIC, 0, struct sw_sync_create_fence_data)
#define SW_SYNC_IOC_INC _IOW(SW_SYNC_IOC_MAGIC, 1, uint32_t)

/* Open the legacy software timeline endpoint used by MT8173 kernels. */
int sw_sync_timeline_create(void) {
    int fd = open("/sys/kernel/debug/sync/sw_sync", O_RDWR);
    if (fd < 0) {
        fd = open("/dev/sw_sync", O_RDWR);
    }
    return fd;
}

/* Advance an existing software timeline, matching the legacy libsync ABI. */
int sw_sync_timeline_inc(int fd, unsigned int count) {
    uint32_t increment = (uint32_t)count;
    return ioctl(fd, SW_SYNC_IOC_INC, &increment);
}

/* Create a fence at the requested timeline value for the legacy gralloc. */
int sw_sync_fence_create(int fd, const char *name, unsigned int value) {
    struct sw_sync_create_fence_data data;
    memset(&data, 0, sizeof(data));
    data.value = (uint32_t)value;
    if (name == NULL) {
        errno = EINVAL;
        return -1;
    }
    strlcpy(data.name, name, sizeof(data.name));

    if (ioctl(fd, SW_SYNC_IOC_CREATE_FENCE, &data) < 0) {
        return -1;
    }
    return data.fence;
}
