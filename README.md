# OpenWrt 25.12.5 — D525 四口千兆软路由定制固件

> 基于 GitHub Actions 自动构建，适配 Intel Atom D525 + 4x Gigabit NIC 平台

## 硬件适配

| 项目 | 配置 |
|------|------|
| CPU | Intel Atom D525 (x86_64, 双核四线程 1.8GHz) |
| 网卡 | 4x Gigabit (Intel 82583V / I211 / Realtek 8111) |
| 内存 | 1GB / 2GB / 4GB 通用 |
| 存储 | ≥ 512MB (SquashFS) / ≥ 1GB (Ext4) |
| 架构 | x86/64 (Generic) |

## 驱动支持

内置全部常见网卡驱动：
- `e1000` / `e1000e` — Intel 千兆 (82583V, 82574L 等)
- `igb` — Intel I211/I350 等
- `igc` — Intel I225/I226 2.5G
- `r8169` — Realtek 千兆
- `forcedeth` — NVIDIA nForce

## 预装插件

| 类别 | 包含 |
|------|------|
| Web 管理 | LuCI + 中文语言包 |
| 网络 | Firewall, UPnP, DDNS, WireGuard, OpenVPN |
| 监控 | Statistics, nlbwmon (流量监控) |
| 工具 | ttyd (Web终端), htop, iperf3, tcpdump, ethtool |
| 存储 | USB 驱动, ext4/vfat/exfat/NTFS3, block-mount |
| DNS | dnsmasq-full |

## 两种固件模式

| 固件 | 特性 | 适用场景 |
|------|------|---------|
| **SquashFS** | 只读系统 + Overlay，重置方便 | 推荐新手 / 稳定部署 |
| **Ext4** | 全可写，空间利用率高 | 需要大量装插件 |

## 下载

从 [Releases](../../releases) 或 [Actions](../../actions) 下载最新构建产物。

写盘命令（Linux）：
```bash
# SquashFS（推荐）
gzip -d openwrt-*-d525*squashfs*.img.gz
sudo dd if=openwrt-*-d525*squashfs*.img of=/dev/sdX bs=4M status=progress

# Ext4
gzip -d openwrt-*-d525*ext4*.img.gz
sudo dd if=openwrt-*-d525*ext4*.img of=/dev/sdX bs=4M status=progress
```

## 默认配置

| 项目 | 默认值 |
|------|--------|
| IP | 192.168.1.1 |
| 用户 | root |
| 密码 | 空（首次登录设置） |
| SSH | 端口 22 |
| LuCI | http://192.168.1.1 |

## 版本信息

- OpenWrt: 25.12.5
- Kernel: 6.12.94
- 构建方式: ImageBuilder (GitHub Actions)
