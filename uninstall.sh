#!/bin/sh
# ============================================================
# MHTools Uninstaller
# 依据 install.sh 生成的清单精确卸载 MHTools 自有文件
# 注意：mihomo 内核为外部依赖，默认不删除（见下方说明）
# ============================================================

RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
NC='\033[0m' # No Color

info()  { echo -e "${GREEN}[✓]${NC} $1"; }
warn()  { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[✗]${NC} $1"; }

# 必须是 root
if [ "$(id -u)" != "0" ]; then
	error "This script must be run as root."
	exit 1
fi

MANIFEST="/usr/share/mhtools/manifest"

# 停止并禁用服务
if [ -x /etc/init.d/mhtools ]; then
	/etc/init.d/mhtools stop 2>/dev/null || true
	/etc/init.d/mhtools disable 2>/dev/null || true
	info "Service stopped and disabled."
fi

# 按清单删除 MHTools 自有文件
if [ -f "$MANIFEST" ]; then
	while read -r f; do
		[ -n "$f" ] && rm -f "$f"
	done < "$MANIFEST"
	rm -f "$MANIFEST"
	info "Removed files listed in manifest."
else
	warn "Manifest not found at $MANIFEST; performing best-effort removal."
	rm -f /www/luci-static/resources/view/mhtools/*.js
	rm -f /www/luci-static/resources/tools/mhtools.js
	rm -rf /usr/share/rpcd/ucode/luci.mhtools
	rm -f /usr/share/rpcd/acl.d/luci-app-mhtools.json
	rm -f /usr/share/luci/menu.d/luci-app-mhtools.json
	rm -f /usr/libexec/mhtools-wrapper /etc/init.d/mhtools
	rm -f /etc/uci-defaults/80-mhtools-init /etc/config/mhtools
fi

# 清理可能由 install.sh 创建的 mihomo 软链（复用 clash-meta 时）
# 仅删除软链，避免误删用户自己的真实二进制
if [ -L /usr/bin/mihomo ]; then
	rm -f /usr/bin/mihomo
	warn "Removed /usr/bin/mihomo symlink created during install."
	warn "If you still need mihomo, reinstall it manually."
fi

# 删除运行时数据目录
rm -rf /etc/mhtools /var/log/mhtools /usr/share/mhtools
info "Removed runtime data directories."

# 重启 rpcd 并清除 LuCI 缓存
if [ -x /etc/init.d/rpcd ]; then
	/etc/init.d/rpcd restart 2>/dev/null || true
fi
rm -f /tmp/luci-indexcache /tmp/luci-modulecache/* 2>/dev/null || true
info "LuCI cache cleared."

echo ""
echo -e " ${GREEN}MHTools uninstalled.${NC}"
echo " Note: mihomo kernel binary (/usr/bin/mihomo, if a real file) was left intact."
echo "       Remove it manually if you no longer need it."
