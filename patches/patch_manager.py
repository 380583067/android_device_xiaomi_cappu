#!/usr/bin/env python3
"""cappu 平台补丁管理：只操作 series.json 列出的项目，不 reset/checkout 用户改动。"""
import argparse
import fcntl
import hashlib
import json
from pathlib import Path
import subprocess
import sys

PATCHES = Path(__file__).resolve().parent
ROOT = PATCHES.parents[3]

def git(project, *args):
    return subprocess.run(['git', '-c', f'safe.directory={project}', '-C', str(project),
                           'apply', *args], capture_output=True, text=True)

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('action', choices=['check', 'install', 'uninstall'])
    parser.add_argument('--root', type=Path, default=ROOT, help='Android 源码根目录')
    args = parser.parse_args()
    root = args.root.resolve()
    if not (root / 'build/envsetup.sh').is_file():
        parser.error(f'不是 Android 源码根目录: {root}')
    # 锁放在临时工作目录，避免向平台源码或补丁目录写入锁文件。
    lockdir = Path('/root/桌面/小米平板3修复/cappu-los19.1')
    lockdir.mkdir(parents=True, exist_ok=True)
    with (lockdir / 'patch-manager.lock').open('w') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        entries = json.loads((PATCHES / 'series.json').read_text())
        records = []
        for entry in entries:
            project = (root / entry['project']).resolve()
            patch = (PATCHES / entry['patch']).resolve()
            if not project.is_relative_to(root) or not patch.is_relative_to(PATCHES):
                raise ValueError('补丁清单包含越界路径')
            if not (project / '.git').exists():
                raise ValueError(f'项目不存在: {project}')
            if hashlib.sha256(patch.read_bytes()).hexdigest() != entry['sha256']:
                raise ValueError(f'补丁校验和不匹配: {patch}')
            if git(project, '--reverse', '--check', str(patch)).returncode == 0:
                state = 'APPLIED'
            elif git(project, '--check', str(patch)).returncode == 0:
                state = 'READY'
            else:
                state = 'CONFLICT'
            print(f'{state:8} {entry["project"]}: {entry["patch"]}', flush=True)
            records.append((state, project, patch))
        if any(state == 'CONFLICT' for state, _, _ in records):
            print('存在冲突，未修改任何文件。请先检查该项目已有改动。', file=sys.stderr)
            return 2
        if args.action == 'check':
            return 0
        changed = []
        # 按清单顺序安装，逆序卸载；已处于目标状态的补丁自动跳过。
        selected = records if args.action == 'install' else list(reversed(records))
        reverse = args.action == 'uninstall'
        for state, project, patch in selected:
            if state != ('APPLIED' if reverse else 'READY'):
                continue
            flags = ['--reverse'] if reverse else []
            result = git(project, *flags, str(patch))
            if result.returncode:
                print(result.stderr, file=sys.stderr)
                # 若执行中发生并发编辑，回滚本次已执行的补丁；绝不重置整个仓库。
                for done_project, done_patch in reversed(changed):
                    rollback = git(done_project, *([] if reverse else ['--reverse']), str(done_patch))
                    if rollback.returncode:
                        print(f'回滚失败，请人工检查: {done_patch}\n{rollback.stderr}', file=sys.stderr)
                return 3
            changed.append((project, patch))
        print(f'{args.action}: 完成，变更 {len(changed)} 个补丁。')
        return 0

if __name__ == '__main__':
    try:
        sys.exit(main())
    except (OSError, ValueError, KeyError) as exc:
        print(f'错误: {exc}', file=sys.stderr)
        sys.exit(2)
