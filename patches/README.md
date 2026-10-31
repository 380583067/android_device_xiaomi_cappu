# cappu LineageOS 19.1 平台补丁

`series.json` 按安装顺序记录源码项目、基线提交、补丁路径和 SHA256。
设备树、内核树和平台源码的可重放改动均登记在本补丁集；vendor 构建入口与元数据修复也按项目归档。

## 使用

从源码根目录执行：

```sh
./device/xiaomi/cappu/patches/check.sh
./device/xiaomi/cappu/patches/install.sh
./device/xiaomi/cappu/patches/uninstall.sh
```

也可在任意目录执行脚本，或用 `--root /绝对路径/源码目录` 指定另一份源码。
`check.sh` 显示 `APPLIED`（已安装）、`READY`（可以安装）、`CONFLICT`（需检查本地改动）。
检查发现冲突或校验和错误时返回非零退出码。安装、卸载可重复执行；卸载按逆序执行。
脚本只对清单中的补丁使用 `git apply`，不重置仓库、不提交代码。

## 分类

| 目录 | 用途 |
| --- | --- |
| `build/toolchains` | 树内 GCC 4.9 包装器兼容 Python 3；RenderScript 旧 Clang 链接到同一源码 sysroot 自带的 ncurses/tinfo 5 |
| `build/repo` | 生成只读构建 manifest 时关闭 repo 的 TRACE_FILE 写入，允许 root/nsjail 环境构建 |
| `build/toolchains` | GCC 4.9 的 Python 3 兼容及旧 RenderScript Clang 所需的 ncurses/tinfo 运行库 |
| `source-compat/libbase` | 为旧 MTK NVRAM 二进制恢复 Android 8 `LogMessage` 构造函数 ELF 符号，同时避免把设备专用兼容签名扩展到 VNDK 公共头文件 ABI |
| `source-compat/hidl` | 给 HIDL 库添加受控兼容源入口，恢复旧 MTK Audio 2.0/common、Radio 1.0 与 Camera device 3.2 helper ABI |
| `source-compat/mtk` | 恢复旧 libcutils UTF 转换、libutils PropertyMap 与调用栈 ABI，并更新 API 32 ARM/ARM64 libcutils 与 libutils VNDK ABI 基线 |
| `source-compat/protobuf` | 为 cappu Widevine blob 提供隔离的 protobuf 2.6 旧 ABI 符号 |
| `source-compat/bionic`, `source-compat/dng-sdk`, `source-compat/frameworks-*` | 旧设备依赖与 Android 12 平台的 libc、DNG、图形/系统接口兼容 |
| `source-compat/chromium-webview` | cappu WebView 补丁集及各架构预置包同步 |
| `source-compat/apps`, `source-compat/services` | Android 12 随附应用/电话兼容，以及无 USB 端口 HAL 时恢复 legacy gadget 的用途切换 |
| `source-compat/vendor` | cappu vendor 构建入口、blob 元数据和相机 HAL 裁剪缓冲 ABI 的可回放修改 |
| `source-compat/build-soong` | 给 Soong 的 RenderScript 编译动作设置源码自带的宿主工具运行库路径 |
| `source-compat/build-make` | 让 ELF 检查识别模块显式声明的系统共享库依赖 |
| `source-compat/frameworks-rs` | 给 RenderScript 的 `bcc_strip_attr` 命令指定源码自带的 ncurses/tinfo ABI 5 运行库 |
| `source-compat/kernel` | cappu 内核主机构建工具与新版链接器参数兼容、MT8173 显示 SMI 时钟恢复候选修复，以及有明确容量的相机裁剪结果回传 |
| `source-compat/device-tree` | cappu Android 12 设备树、Treble、VINTF、init、旧 HAL、相机和 Wi-Fi 兼容修改；Wi-Fi 补丁通过 NetworkStack RRO 使用已验证可达的联网探测端点，保留门户检测 |
| `source-compat/bluetooth` | 在 cappu 上实时定时器或 SCHED_FIFO 权限被拒时，蓝牙回退到普通调度继续启动 |

相机裁剪调查通过本地 vendor HAL 反汇编确认，`LscMgr2::getSensorResolution()` 在栈上
准备完整的 32 字节 `SENSOR_WINSIZE_INFO_STRUCT`，但发起 `GET_CROP_INFO` 时只把 4 字节
场景号长度传给内核作为输入长度。内核兼容路径只读取这 4 字节场景号，再将裁剪结构写回
同一用户缓冲区，并把返回长度更新为 32 字节；不会把数据写入内核仅按 4 字节分配的副本。
此前误判为无输出容量的路径及未被相机调用的 VC 信息试验已撤回。当前修复仍需以 TSF 不再
报告零尺寸裁剪、相机 HAL 不再崩溃且取景器出现实时画面作为设备验收条件。
旧 `libutils::CallStack::update` 兼容入口不做栈回溯并返回空帧，避免把 `libbacktrace`
依赖扩散到 VNDK/APEX；旧 vendor 日志中的调用栈文本因此为空。Android 12 的
`libutilscallstack` 仍保留原生回溯实现。

Android 用户空间使用 `prebuilts/clang/host/linux-x86/clang-r416183b1`。
内核目标代码使用树内 AArch64 GCC 4.9，内核主机工具使用树内 Clang。
RenderScript 保留平台指定的 `clang-3289846`，没有替换成主机编译器。

补丁管理脚本依赖 Bash、Python 3、Git。运行记录和锁文件放在
`/root/桌面/小米平板3修复/cappu-los19.1`。测试副本已验证重复安装、重复卸载、
符号链接补丁以及遇到冲突时保留本地文件。

## 后续源码修改约定

后续为解决编译或运行问题而修改任意 ROM 源码（包括设备树、内核树、vendor 与平台项目）时，必须同时生成对应的
统一 diff 补丁，放入上面的分类目录，并在 `series.json` 登记项目基线提交和补丁
SHA256。补丁应包含新建文件；完成后运行 `check.sh`，确认状态为 `APPLIED`。
不要只保留源码工作树改动而遗漏补丁，这样才能在重新同步源码后用 `install.sh`
恢复相同修复。
