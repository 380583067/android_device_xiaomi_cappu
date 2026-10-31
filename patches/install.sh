#!/usr/bin/env bash
# cappu Android 12 平台补丁：从任意目录调用；重复执行安全，冲突时停止。
set -euo pipefail
script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
exec python3 "$script_dir/patch_manager.py" install "$@"
