/*
 * Android 8 MTK camera HIDL ABI bridge for DebugInfo's string formatter.
 *
 * The generated Android 12 HIDL header keeps this formatter inline, while the
 * old provider DSO imports its out-of-line C++ ABI symbol. Export that exact
 * symbol and use the generated DebugInfo fields so both ARM32 and ARM64 blobs
 * receive the same diagnostic text without changing HIDL transport behavior.
 */
#include <android/hidl/base/1.0/types.h>

#include <string>

using android::hidl::base::V1_0::DebugInfo;

__attribute__((visibility("default")))
std::string cappu_hidl_debuginfo_to_string(const DebugInfo& info)
        __asm__("_ZN7android4hidl4base4V1_08toStringERKNS2_9DebugInfoE");

std::string cappu_hidl_debuginfo_to_string(const DebugInfo& info) {
    const char* architecture = "UNKNOWN";
    switch (info.arch) {
        case DebugInfo::Architecture::IS_64BIT:
            architecture = "IS_64BIT";
            break;
        case DebugInfo::Architecture::IS_32BIT:
            architecture = "IS_32BIT";
            break;
        case DebugInfo::Architecture::UNKNOWN:
        default:
            break;
    }

    return "{.pid = " + std::to_string(info.pid) + ", .ptr = " +
            std::to_string(info.ptr) + ", .arch = " + architecture + "}";
}
