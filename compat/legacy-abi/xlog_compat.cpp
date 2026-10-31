/*
 * Device-local Android 12 compatibility for the legacy MTK xlog entry point.
 * The old xlog ABI passes its tag, format string, and priority in xlog_record;
 * forward the same varargs through Android's supported liblog API.
 */
#include <android/log.h>

#include <stdarg.h>

struct xlog_record {
    const char* tag_str;
    const char* fmt_str;
    int prio;
};

extern "C" int __xlog_buf_printf(int bufid, const struct xlog_record* record,
        ...) {
    (void)bufid;
    if (record == nullptr || record->tag_str == nullptr || record->fmt_str == nullptr) {
        return -1;
    }

    va_list args;
    va_start(args, record);
    const int result = __android_log_vprint(record->prio, record->tag_str,
            record->fmt_str, args);
    va_end(args);
    return result;
}
