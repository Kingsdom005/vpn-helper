

# 🌐 VPN Helper

> 一个轻量级、高可用、终端友好的Clash VPN 工具，支持一键启停、状态检测、动态代理配置与环境注入。简洁可靠，兼容大部分 Linux 终端环境。

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT) [![Linux](https://img.shields.io/badge/Platform-Linux-brightgreen.svg)](https://www.linux.org/) ![Terminal Friendly](https://img.shields.io/badge/CLI-Optimized-orange.svg)

---

## 📁 项目目录结构

```bash
[/your/path/to]/vpn/
├── clash/                # Clash / Mihomo 程序目录
│   ├── mihomo            # 主程序二进制
│   ├── config.yaml       # 当前使用的配置
│   └── vpn.pid           # 启动时记录的进程 ID
├── configHistory/        # 旧配置备份
├── config/
│   └── vpn-proxy.env     # 当前 ALL_PROXY 的导出文件
├── log/
│   └── vpn.log           # 所有操作日志
└── script/
    ├── vpn               # 主控制脚本（source 调用）
    └── profile_hook.sh   # 环境变量注入钩子
```

------

## 🚀 快速开始

### 1. 安装配置（首次执行）

```bash
sudo apt install -y bc
wget https://github.com/Kingsdom005/vpn-helper/archive/refs/tags/release1.0.tar.gz
cd [/your/path/to]/vpn
bash ./set_vpn.sh
source ~/.bashrc
chmod 777 [path/to]/vpn/clash/mihomo
```

📌 **自动完成以下操作**：

- 替换脚本路径为当前实际路径
- 向 `~/.bashrc` 添加：
  - `vpn()` 命令函数
  - `source` 加载 `profile_hook.sh`
- 自动生效，无需重启终端

### 2. 使用方式

```bash
vpn start          # 启动 VPN，并导出代理变量
vpn stop           # 停止 VPN，清除代理变量
vpn status         # 检查当前 VPN 是否正常连接
vpn config <cfg.yaml>  # 替换当前配置文件（自动备份）
```

📍 **所有日志记录位置**：

```text
[/your/path/to]/vpn/log/*.log
```

------

## ✅ 功能亮点

- **📦 开箱即用**：一键安装，自动配置
- **📡 状态检测**：智能判断 ALL_PROXY 和网络连通性
- **♻️ 动态路径支持**：适配任意安装路径
- **🧠 持久代理修改和清理**：自动写入 `~/.bashrc`
- **🛠️ 配置热切换**：自动备份历史配置，安全更新

------

## 🧪 使用示例

bash

```
(base) root@fb2b5b9dc6f3:~/vpn/clash# vpn start 
Starting VPN, please wait...
Logs are being saved to: /test00/vpn/log/mihomo_output.log
Waiting for VPN proxy to be ready[1]+  Exit 126                nohup "$VPN_BIN" -d . >> "$LOG_DIR/mihomo_output.log" 2>&1
Waiting for VPN proxy to be ready... ✅ Ready!
VPN start process completed.
(base) root@fb2b5b9dc6f3:~/vpn/clash# curl -v google.com
* processing: google.com
* Uses proxy env variable ALL_PROXY == 'http://127.0.0.1:7890'
*   Trying 127.0.0.1:7890...
* Connected to 127.0.0.1 (127.0.0.1) port 7890
> GET http://google.com/ HTTP/1.1
> Host: google.com
> User-Agent: curl/8.2.1
> Accept: */*
> Proxy-Connection: Keep-Alive
> 
< HTTP/1.1 301 Moved Permanently
< Content-Length: 219
< Cache-Control: public, max-age=2592000
< Connection: keep-alive
< Content-Security-Policy-Report-Only: object-src 'none';base-uri 'self';script-src 'nonce-NdGQWWj9LTmceFOd7kQUDg' 'strict-dynamic' 'report-sample' 'unsafe-eval' 'unsafe-inline' https: http:;report-uri https://csp.withgoogle.com/csp/gws/other-hp
< Content-Type: text/html; charset=UTF-8
< Date: Thu, 31 Jul 2025 08:50:10 GMT
< Expires: Sat, 30 Aug 2025 08:50:10 GMT
< Keep-Alive: timeout=4
< Location: http://www.google.com/
< Proxy-Connection: keep-alive
< Server: gws
< X-Frame-Options: SAMEORIGIN
< X-Xss-Protection: 0
< 
<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
<TITLE>301 Moved</TITLE></HEAD><BODY>
<H1>301 Moved</H1>
The document has moved
<A HREF="http://www.google.com/">here</A>.
</BODY></HTML>
* Connection #0 to host 127.0.0.1 left intact
(base) root@fb2b5b9dc6f3:~/vpn/clash# vpn stop
VPN stopped successfully. ALL_PROXY environment variable cleared.
(base) root@fb2b5b9dc6f3:~/vpn/clash# echo $ALL_PROXY

(base) root@fb2b5b9dc6f3:~/vpn/clash# 
```

------

## ⚠️ 重要注意事项

1. 配置

2. **路径变更**：vpn config <cfg.yaml>  # 替换当前配置文件（自动备份）

首次运行`set_vpn.sh`脚本可忽略。

如果vpn应用在执行了一次`set_vpn.sh`脚本后，如果想将项目挪动到新位置，需要将这次运行添加到~/.bashrc中的如下类似内容删除掉，然后运行`set_vpn.sh`脚本即可，脚本会自动检测是否有这两个配置，如果有则不会添加新的配置。

```bash
# VPN helper function auto-added by set_vpn.sh
vpn() {
  source "~/vpn/script/vpn" "$@"
}


# Load VPN profile hook environment
source "~/vpn/script/profile_hook.sh"
```

------

## 📄 License

MIT License © 2023，使用请注明出处，禁止基于本项目开发商用软件！

> 项目持续维护中，欢迎提交 Issue 和 PR！
>
> GitHub 仓库: https://github.com/Kingsdom005/vpn-helper
