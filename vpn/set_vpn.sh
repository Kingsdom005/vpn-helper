#!/bin/bash
set -e

VPN_ROOT="$(pwd)"
SCRIPT_DIR="$VPN_ROOT/script"
PROFILE_HOOK="$SCRIPT_DIR/profile_hook.sh"
VPN_SCRIPT="$SCRIPT_DIR/vpn"
BASHRC="$HOME/.bashrc"

echo "Configuring VPN environment in: $VPN_ROOT"

# 更新 profile_hook.sh 中 VPN_ROOT
if [ -f "$PROFILE_HOOK" ]; then
    echo "Updating $PROFILE_HOOK with dynamic VPN_ROOT"
    if grep -q '^VPN_ROOT=' "$PROFILE_HOOK"; then
        sed -i -E "s|^VPN_ROOT=.*|VPN_ROOT=\"$VPN_ROOT\"|" "$PROFILE_HOOK"
    else
        sed -i "1i VPN_ROOT=\"$VPN_ROOT\"" "$PROFILE_HOOK"
    fi
else
    echo "Warning: $PROFILE_HOOK not found!"
fi

# 更新 vpn 脚本中 VPN_ROOT
if [ -f "$VPN_SCRIPT" ]; then
    echo "Updating $VPN_SCRIPT with dynamic VPN_ROOT"
    if grep -q '^VPN_ROOT=' "$VPN_SCRIPT"; then
        sed -i -E "s|^VPN_ROOT=.*|VPN_ROOT=\"$VPN_ROOT\"|" "$VPN_SCRIPT"
    else
        sed -i "1i VPN_ROOT=\"$VPN_ROOT\"" "$VPN_SCRIPT"
    fi
else
    echo "Warning: $VPN_SCRIPT not found!"
fi

# 添加vpn()函数到bashrc，避免重复
FUNC_DEF="
# VPN helper function auto-added by set_vpn.sh
vpn() {
  source \"$VPN_ROOT/script/vpn\" \"\$@\"
}
"

if grep -q 'vpn() {' "$BASHRC"; then
    echo "vpn() function already exists in $BASHRC, skipping add."
else
    echo "Adding vpn() function to $BASHRC"
    echo "$FUNC_DEF" >> "$BASHRC"
fi

# 添加 source profile_hook.sh 到 bashrc，避免重复
PROFILE_HOOK_SOURCE="source \"$PROFILE_HOOK\""
if grep -Fxq "$PROFILE_HOOK_SOURCE" "$BASHRC"; then
    echo "Profile hook already sourced in $BASHRC, skipping add."
else
    echo "Adding source for profile_hook.sh to $BASHRC"
    echo "" >> "$BASHRC"
    echo "# Load VPN profile hook environment" >> "$BASHRC"
    echo "$PROFILE_HOOK_SOURCE" >> "$BASHRC"
fi

echo "Sourcing $BASHRC to apply changes in current shell..."
source "$BASHRC"

echo "Setup complete! Please run 'source ~/.bashrc' first, and you can now use 'vpn' command and environment variables will load automatically in new terminals."
