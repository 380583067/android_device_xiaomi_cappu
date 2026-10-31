# cappu Android 12：午餐目标统一在 AndroidProducts.mk 注册。
# 保留此文件供旧调用者 source；不再调用已移除的 add_lunch_combo。

# Android 12 的 RenderScript 宿主工具（llvm-rs-cc、bcc_strip_attr）仍依赖
# ncurses/tinfo ABI 5。新主机系统通常只安装 ABI 6；LineageOS 源码自带的
# ABI 5 兼容库在 GCC 预置工具链 sysroot 中，但这些工具的 RUNPATH 只搜索
# out/host/.../lib64 和 out/soong/host/.../lib64。这里在加载构建环境时补齐
# 两个输出目录的链接，避免每次手动构建或清理 out 后再手工修复。
if command -v gettop >/dev/null 2>&1; then
    _CAPPU_BUILD_TOP="$(gettop)"
    if [ -n "${OUT_DIR:-}" ]; then
        _CAPPU_OUT_DIR="$OUT_DIR"
    elif [ -n "${OUT_DIR_COMMON_BASE:-}" ]; then
        _CAPPU_OUT_DIR="${OUT_DIR_COMMON_BASE%/}/${_CAPPU_BUILD_TOP##*/}"
    else
        _CAPPU_OUT_DIR=out
    fi

    case "$_CAPPU_OUT_DIR" in
        /*) ;;
        *) _CAPPU_OUT_DIR="$_CAPPU_BUILD_TOP/$_CAPPU_OUT_DIR" ;;
    esac

    _CAPPU_NCURSES_SOURCE="$_CAPPU_BUILD_TOP/prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.17-4.8/sysroot/usr/lib"
    if [ -f "$_CAPPU_NCURSES_SOURCE/libncurses.so.5.9" ] && [ -f "$_CAPPU_NCURSES_SOURCE/libtinfo.so.5.9" ]; then
        for _CAPPU_HOST_LIB_DIR in \
            "$_CAPPU_OUT_DIR/host/linux-x86/lib64" \
            "$_CAPPU_OUT_DIR/soong/host/linux-x86/lib64"; do
            mkdir -p "$_CAPPU_HOST_LIB_DIR"
            # Do not replace a real library supplied by the host build; update
            # only missing entries or symlinks from an earlier source-tree path.
            if [ ! -e "$_CAPPU_HOST_LIB_DIR/libncurses.so.5" ] || [ -L "$_CAPPU_HOST_LIB_DIR/libncurses.so.5" ]; then
                ln -sfn "$_CAPPU_NCURSES_SOURCE/libncurses.so.5.9" "$_CAPPU_HOST_LIB_DIR/libncurses.so.5"
            fi
            if [ ! -e "$_CAPPU_HOST_LIB_DIR/libtinfo.so.5" ] || [ -L "$_CAPPU_HOST_LIB_DIR/libtinfo.so.5" ]; then
                ln -sfn "$_CAPPU_NCURSES_SOURCE/libtinfo.so.5.9" "$_CAPPU_HOST_LIB_DIR/libtinfo.so.5"
            fi
        done
    else
        echo "cappu: LineageOS prebuilt ncurses ABI 5 libraries are missing under $_CAPPU_NCURSES_SOURCE" >&2
    fi

    unset _CAPPU_BUILD_TOP _CAPPU_OUT_DIR _CAPPU_NCURSES_SOURCE _CAPPU_HOST_LIB_DIR
fi
