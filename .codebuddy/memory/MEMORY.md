# MHTools 项目记忆

## 项目概要
- 仓库：GitHub luke029/MHTools，纯源码仓库，无编译产物
- 用途：OpenWrt 25.12+ 上管理 mihomo 代理的 LuCI 应用
- 发布格式：tar.gz（含 install.sh + luci-app-mhtools/）

## 部署方式
- **Release**：GitHub Release 下载 mhtools-release.tar.gz
- **安装**：`tar xzf mhtools-release.tar.gz && sh install.sh`
- install.sh 自动处理依赖：
  - `kmod-tun`：通过 apk/opkg 安装 + modprobe
  - `mihomo` 内核：从 MetaCubeX GitHub Release 自动下载对应架构的二进制
- 不再使用 APK 格式（签名验证问题 + 非官方仓库依赖无法声明）

## 包配置
- arch=all（纯脚本包，不依赖架构）
- 运行时依赖：kmod-tun、mihomo（由 install.sh 自动处理）

## 发版流程
```bash
echo "X.X.X" > VERSION && git add . && git commit -m "..." && git push
git tag vX.X.X && git push --tags
```

## 结构
```
MHTools/
├── VERSION
├── install.sh                # 一键安装脚本
├── .github/workflows/build.yml  # CI: 打包 tar.gz
├── scripts/
│   └── build_release.py     # 打包 tar.gz
└── luci-app-mhtools/        # 包内容
    ├── htdocs/              # LuCI 前端 JS
    └── root/                # 系统文件（config/init/ucode/acl/menu）
```
