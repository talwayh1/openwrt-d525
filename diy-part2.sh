#!/bin/bash
# ============================================================
# diy-part2.sh — 在 feeds install 之后执行的定制脚本
# 用途：安装额外包、修改源码、添加自定义文件等
# ============================================================

# 设置默认 root 密码为 "password"（首次登录后建议修改）
sed -i 's/root:::0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/' \
    package/base-files/files/etc/shadow 2>/dev/null || true

# 调整内核参数 — D525 优化
# - net.core.default_qdisc=fq_codel：更好的 QoS
# - net.ipv4.tcp_congestion_control=bbr：BBR 拥塞控制
mkdir -p files/etc/sysctl.d
cat > files/etc/sysctl.d/99-d525-tune.conf << 'EOF'
# D525 Router Performance Tuning
net.core.default_qdisc=fq_codel
net.ipv4.tcp_congestion_control=bbr
net.core.rmem_max=16777216
net.core.wmem_max=16777216
net.ipv4.tcp_rmem=4096 87380 16777216
net.ipv4.tcp_wmem=4096 65536 16777216
net.core.netdev_max_backlog=5000
net.ipv4.tcp_fastopen=3
EOF

# 允许 root 通过 SSH 登录（使用密码）
mkdir -p files/etc/ssh
cat > files/etc/ssh/sshd_config << 'EOF'
Port 22
PermitRootLogin yes
PasswordAuthentication yes
EOF

# 添加首次启动脚本 — 检测内存大小并优化
mkdir -p files/etc/uci-defaults
cat > files/etc/uci-defaults/99-d525-init << 'D525INIT'
#!/bin/sh
# D525 首次启动自检脚本

# 检测内存大小
MEM_KB=$(grep MemTotal /proc/meminfo | awk '{print $2}')
MEM_MB=$((MEM_KB / 1024))

# 记录硬件信息
echo "D525 Router Init: Memory=${MEM_MB}MB" >> /tmp/d525-init.log

# 创建 dmesg 缓冲区更大一些（D525 日志）
echo 'kernel.printk = 3 4 1 3' >> /etc/sysctl.conf

exit 0
D525INIT
chmod +x files/etc/uci-defaults/99-d525-init

echo "✅ diy-part2.sh done"
