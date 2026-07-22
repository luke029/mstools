#!/usr/bin/env python3
"""从 .apk.meta 文件生成 APKINDEX.tar.gz"""

import sys
import os
import json
import hashlib
import tarfile


def generate_index(apk_dir, output_dir):
    """扫描 apk_dir 下所有 .apk，读取对应 .meta 生成 APKINDEX"""
    os.makedirs(output_dir, exist_ok=True)

    apk_files = sorted([f for f in os.listdir(apk_dir) if f.endswith('.apk')])
    if not apk_files:
        print("未找到 .apk 文件")
        return 1

    lines = []
    for apk_name in apk_files:
        apk_path = os.path.join(apk_dir, apk_name)
        meta_path = apk_path + '.meta'

        # SHA256 + 文件大小
        with open(apk_path, 'rb') as f:
            apk_data = f.read()
        sha256 = hashlib.sha256(apk_data).hexdigest()
        file_size = len(apk_data)

        # 读取元信息
        meta = {}
        if os.path.isfile(meta_path):
            with open(meta_path) as mf:
                meta = json.load(mf)

        print(f"  {meta.get('pkgname', apk_name)}-{meta.get('pkgver', '?')}  "
              f"SHA256={sha256[:16]}...  size={file_size}")

        lines.append(f"C:{sha256}")
        lines.append(f"P:{meta.get('pkgname', '')}")
        lines.append(f"V:{meta.get('pkgver', '')}")
        lines.append(f"A:{meta.get('arch', 'unknown')}")
        lines.append(f"S:{file_size}")
        lines.append(f"I:{meta.get('size', 0)}")
        lines.append(f"T:{meta.get('pkgdesc', '')}")
        if meta.get('license'):
            lines.append(f"L:{meta['license']}")
        if meta.get('origin'):
            lines.append(f"o:{meta['origin']}")
        if meta.get('maintainer'):
            lines.append(f"m:{meta['maintainer']}")
        if meta.get('url'):
            lines.append(f"U:{meta['url']}")
        if meta.get('depends'):
            lines.append(f"D:{' '.join(meta['depends'])}")
        lines.append("")

    index_content = '\n'.join(lines) + '\n'

    idx_path = os.path.join(output_dir, 'APKINDEX')
    with open(idx_path, 'w') as f:
        f.write(index_content)

    tar_path = os.path.join(output_dir, 'APKINDEX.tar.gz')
    with tarfile.open(tar_path, 'w:gz') as tar:
        tar.add(idx_path, arcname='APKINDEX')

    print(f"\nAPKINDEX 已生成: {tar_path}")
    print(f"  共 {len(apk_files)} 个包")
    return 0


if __name__ == '__main__':
    if len(sys.argv) != 3:
        print(f"Usage: {sys.argv[0]} <apk_dir> <output_dir>")
        sys.exit(1)
    sys.exit(generate_index(sys.argv[1], sys.argv[2]))
