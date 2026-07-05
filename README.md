# OpenWrt 25.12.x — D525 四口千兆软路由定制固件

[![Build D525 OpenWrt](https://github.com/talwayh1/openwrt-d525/actions/workflows/build.yml/badge.svg)](https://github.com/talwayh1/openwrt-d525/actions/workflows/build.yml)

> 基于 Lean's LEDE + GitHub Actions 每周自动编译
>
> 适配 Intel Atom D525 + 4×Gigabit NIC 软路由平台

## 硬件适配

| 项目 | 配置 |
|------|------|
| CPU | **Intel Atom D525** (x86_64, 双核四线程 1.8GHz) |
| 网卡 | 4× Gigabit (Intel 82583V / I211 / Realtek 8111) |
| 内存 | 通用 **1GB / 2GB / 4GB** |
| 存储 | ≥ 512MB (SquashFS) 或 ≥ 1GB (Ext4) |
| 架构 | x86/64 (Generic) |

## 研究来源

本固件配置参考了以下中国 OpenWrt 社区顶级项目：

| 项目 | Stars | 说明 |
|------|-------|------|
| [coolsnowwolf/lede](https://github.com/coolsnowwolf/lede) | ⭐31.5K | Lean's LEDE — 中国最流行的OpenWrt源码 |
| [immortalwrt/immortalwrt](https://github.com/immortalwrt/immortalwrt) | ⭐11.1K | ImmortalWrt — 中国大陆用户专用 |
| [kiddin9/OpenWrt_x86...](https://github.com/kiddin9/OpenWrt_x86-r2s-r4s-r5s-N1) | ⭐8.9K | x86软路由固件定制 |
| [P3TERX/Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt) | ⭐7.6K | GitHub Actions云编译模板 |
| [kenzok8/openwrt-packages](https://github.com/kenzok8/openwrt-packages) | — | 大型中文社区软件包集合 |
| [fw876/helloworld](https://github.com/fw876/helloworld) | — | SSR/SSR+/V2Ray/Xray 全家桶 |

## 预装插件全景

| 类别 | 包含 |
|------|------|
| 🔐 **科学上网** | SSR-Plus (含Xray/Trojan/SS/SSR/V2Ray), OpenClash |
| 🐳 **Docker** | docker-ce + LuCI管理界面 |
| 🚫 **广告过滤** | AdGuardHome |
| 🎵 **解锁流媒体** | 解锁网易云音乐, 阿里云盘WebDAV |
| 📡 **网络** | MWAN3(多拨/负载均衡), DDNS, UPnP, QoS, Nlbwmon(流量监控) |
| 🔒 **VPN** | WireGuard, OpenVPN |
| 📊 **监控** | NetData, htop, iperf3, tcpdump, iftop |
| 🖥️ **远程** | TTYD(Web终端), Frp(内网穿透) |
| 💾 **存储** | Aria2下载, CIFS挂载, 全文件系统(ext4/NTFS/exFAT/F2FS/NFS) |
| 🌐 **DDNS** | 支持阿里云/腾讯云/Cloudflare 等 |

## 网卡驱动覆盖

```
Intel:    e1000, e1000e, igb, igbvf, igc, ixgbe, i40e
Realtek:  r8169, r8168, r8125 (2.5G)
Broadcom: bnx2, bnx2x, tg3
其他:     forcedeth, alx, 8139cp/too, pcnet32, tulip, via-velocity
虚拟化:   vmxnet3, amazon-ena
无线USB:  mt76全家桶 + ath9k/ath10k + rtlwifi
```

## 默认配置

| 项目 | 值 |
|------|-----|
| 管理 IP | **192.168.1.1** |
| 用户名 | **root** |
| 密码 | **password** |
| SSH 端口 | 22 |
| 时区 | Asia/Shanghai (CST+8) |
| 网口 | eth0=WAN, eth1-3=LAN桥接 |
| DNS | 223.5.5.5, 119.29.29.29 (阿里/腾讯) |

## 下载安装

从 [Releases](../../releases) 下载最新固件。

```bash
# 写盘 (Linux)
gzip -d openwrt-*-x86-64-generic-squashfs-combined.img.gz
sudo dd if=openwrt-*-x86-64-generic-squashfs-combined.img of=/dev/sdX bs=4M status=progress

# 写入后重启，首次启动约需30秒
# 访问 http://192.168.1.1
# 用户: root  密码: password
```

## 构建方式

本仓库使用 **GitHub Actions 完整源码编译**：
1. `feeds.conf.default` — 中国社区feeds源（fw876/kenzok8/vernesong等）
2. `.config` — x86_64内核+包选择
3. `diy-part1.sh` — 编译前自定义（时区/主机名）
4. `diy-part2.sh` — feeds后自定义（密码/内核调优/首次启动脚本）
5. `files/` — rootfs覆盖文件（网络配置/系统配置）

工作流参考 [P3TERX/Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt) 模板，适配 D525 硬件。
