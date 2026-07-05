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
# ============================================================
# D525 多宽带聚合性能调优
# Intel Atom D525 1.8GHz + 1G/2G/4G RAM
# ============================================================

# --- 拥塞控制 ---
net.core.default_qdisc=fq_codel
net.ipv4.tcp_congestion_control=bbr

# --- TCP 缓冲区（适配 1-4GB 内存） ---
net.core.rmem_max=16777216
net.core.wmem_max=16777216
net.ipv4.tcp_rmem=4096 87380 16777216
net.ipv4.tcp_wmem=4096 65536 16777216

# --- 网络队列（多WAN需要更大的backlog） ---
net.core.netdev_max_backlog=5000
net.core.somaxconn=4096

# --- 连接追踪（多WAN关键：扩大conntrack表） ---
# 1GB内存: 65536, 2GB: 131072, 4GB: 262144
net.netfilter.nf_conntrack_max=131072
net.netfilter.nf_conntrack_tcp_timeout_established=7440
net.netfilter.nf_conntrack_tcp_timeout_time_wait=30
net.netfilter.nf_conntrack_tcp_timeout_close_wait=15
net.netfilter.nf_conntrack_tcp_timeout_fin_wait=10
net.netfilter.nf_conntrack_udp_timeout=60
net.netfilter.nf_conntrack_udp_timeout_stream=180

# --- 路由缓存（MWAN3 多路由表） ---
net.ipv4.route.max_size=524288
net.ipv4.route.gc_thresh=131072
net.ipv4.route.gc_timeout=300
net.ipv4.route.gc_interval=60
net.ipv4.route.gc_elasticity=8
net.ipv4.route.gc_min_interval_ms=500

# --- ARP 优化 ---
net.ipv4.neigh.default.gc_thresh1=2048
net.ipv4.neigh.default.gc_thresh2=4096
net.ipv4.neigh.default.gc_thresh3=8192

# --- TCP Fast Open ---
net.ipv4.tcp_fastopen=3

# --- 多WAN RP过滤（必须关闭，否则跨WAN流量会被丢弃） ---
net.ipv4.conf.all.rp_filter=0
net.ipv4.conf.default.rp_filter=0
net.ipv4.conf.all.accept_source_route=1
net.ipv4.conf.default.accept_source_route=1

# --- 内核转发 ---
net.ipv4.ip_forward=1
net.ipv6.conf.all.forwarding=1

# --- 禁用不必要的开销 ---
net.ipv4.tcp_slow_start_after_idle=0
net.ipv4.tcp_mtu_probing=1
net.ipv4.tcp_tw_reuse=1
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
