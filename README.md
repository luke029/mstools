# MHTools

## 目录结构

```text
MHTools/
├── VERSION
├── install.sh
├── uninstall.sh
└── luci-app-mhtools/
    ├── htdocs/luci-static/resources/view/mhtools/
    │   ├── overview.js
    │   └── log.js
    ├── htdocs/luci-static/resources/tools/mhtools.js
    └── root/
        ├── usr/share/rpcd/ucode/luci.mhtools
        ├── etc/init.d/mhtools
        └── etc/config/mhtools
```

## 依赖

- OpenWrt / ImmortalWrt
- `kmod-tun`
- `nftables`
- `python3-yaml`
- `ca-certificates`
- `wget-ssl` / `curl`
- `mihomo` 二进制（需自行放置到 `/usr/bin/mihomo`，或由安装脚本自动下载）

## 安装

```sh
wget https://github.com/luke029/MHTools/releases/latest/download/mhtools-v2.1.0.tar.gz
tar xzf mhtools-v2.1.0.tar.gz
cd MHTools
sh install.sh
```

## 卸载

```sh
sh uninstall.sh
```
