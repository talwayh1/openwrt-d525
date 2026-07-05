#!/bin/bash
# ============================================================
# diy-part1.sh — 在 feeds update 之前执行的定制脚本
# 用途：修改默认配置、添加 feeds 源、内核 patch 等
# ============================================================

# 修改默认 IP 为 192.168.1.1（LEDE 默认就是，这里显式确认）
sed -i 's/192.168.1.1/192.168.1.1/g' package/base-files/files/bin/config_generate

# 修改时区为 Asia/Shanghai
sed -i "s/timezone='UTC'/timezone='CST-8'/" package/base-files/files/bin/config_generate
sed -i "/timezone='CST-8'/a\\\t\t\t\t\tset system.@system[-1].zonename='Asia/Shanghai'" package/base-files/files/bin/config_generate

# 修改默认主机名
sed -i "s/hostname='OpenWrt'/hostname='D525-Router'/" package/base-files/files/bin/config_generate

# 调整分区大小 — 给 D525 足够的 overlay 空间
# D525 通常配 8-32GB SSD，给 1GB overlay 很充裕
sed -i 's/CONFIG_TARGET_ROOTFS_PARTSIZE=.*/CONFIG_TARGET_ROOTFS_PARTSIZE=1024/' .config 2>/dev/null || true

# 添加额外的 feeds（如 feeds.conf.default 里没有的）
# echo 'src-git custom https://github.com/xxx/xxx' >> feeds.conf.default

echo "✅ diy-part1.sh done"
