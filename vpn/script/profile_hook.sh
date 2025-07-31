VPN_ROOT="/test00/vpn"
#!/bin/bash
# 自动加载 VPN 环境变量
if [ -f /vpn/config/vpn-proxy.env ]; then
    source /vpn/config/vpn-proxy.env
fi