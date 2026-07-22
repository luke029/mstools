# MHTools

OpenWrt / ImmortalWrt 上管理 [mihomo](https://github.com/MetaCubeX/mihomo) 代理的 LuCI 应用。

## 安装

```bash
# 下载并解压
wget https://github.com/luke029/MHTools/releases/latest/download/mhtools-v2.0.3.tar.gz
tar xzf mhtools-v2.0.3.tar.gz

# 一键安装（自动处理依赖）
sh install.sh
```

`install.sh` 会自动：
- 检测并安装 `kmod-tun`（通过系统包管理器）
- 获取 mihomo 内核二进制（**优先复用**已存在的 mihomo/clash-meta，否则依次尝试官方源与 GitHub 代理镜像下载；全部失败则跳过下载、不阻断 LuCI 安装，稍后手动放置即可）
- 拷贝所有文件、注册服务，并生成安装清单 `/usr/share/mhtools/manifest`

## 卸载

```bash
sh uninstall.sh
```

`uninstall.sh` 依据安装清单精确移除 MHTools 自有文件、停止并禁用服务、清理运行时数据目录。
> 注意：mihomo 内核为外部依赖，默认保留；仅当它是安装时创建的软链时才会被移除。

## 手动打包

```bash
tar czf mhtools-vX.X.X.tar.gz install.sh uninstall.sh luci-app-mhtools/
```

## 目录结构

```
MHTools/
├── VERSION
├── install.sh                         # 安装脚本
├── uninstall.sh                       # 卸载脚本（依据安装清单精确清理）
└── luci-app-mhtools/
    ├── htdocs/                        # LuCI 前端页面
    └── root/
        ├── etc/config/mhtools          # UCI 配置定义
        ├── etc/init.d/mhtools          # 服务管理脚本
        ├── etc/uci-defaults/           # 首次安装初始化
        └── usr/
            ├── libexec/mhtools-wrapper # 权限代理
            └── share/
                ├── luci/menu.d/        # 菜单注册
                └── rpcd/               # Lua → ucode 中间层
```

## 使用

1. 打开 LuCI → Services → MHTools
2. 上传 mihomo 配置文件（`.yaml`）
3. 启用并启动服务

## 依赖

安装脚本自动处理所有依赖，无需手动安装。

## License

MIT
