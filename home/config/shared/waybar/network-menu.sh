#!/usr/bin/env bash

NET_INFO=$(~/.config/waybar/network-info.sh)

PUB_IP=$(echo "$NET_INFO" | grep -oP '"pub_ip":\s*"\K[^"]+')
PORT=$(echo "$NET_INFO" | grep -oP '"port":\s*"\K[^"]+')
COUNTRY=$(echo "$NET_INFO" | grep -oP '"country":\s*"\K[^"]+')

ACTION=$1

notify() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "$@"
    fi
}

toggle_wg() {
    if systemctl is-active --quiet wg-quick-wg0.service; then
        systemctl stop wg-quick-wg0.service || pkexec systemctl stop wg-quick-wg0.service
        notify -u normal -a "WireGuard" "🔒 WIREGUARD DISCONNECTED" "WireGuard (wg0) interface stopped."
    else
        systemctl start wg-quick-wg0.service || pkexec systemctl start wg-quick-wg0.service
        notify -u normal -a "WireGuard" "🛡️ WIREGUARD CONNECTED" "WireGuard (wg0) interface started."
    fi
    pkill -RTMIN+8 waybar 2>/dev/null
}

if [[ "$ACTION" == "copy-port" ]]; then
    if [[ -n "$PORT" && "$PORT" != "N/A" ]]; then
        echo -n "$PORT" | wl-copy
        notify -u normal -a "Network" "⚡ PORT COPIED" "VPN Port $PORT copied to clipboard!"
    else
        notify -u critical -a "Network" "⚠️ COPY FAILED" "No active forwarded port available."
    fi
    exit 0
fi

if [[ "$ACTION" == "toggle-wg" ]]; then
    toggle_wg
    exit 0
fi

# Context Menu Options
if systemctl is-active --quiet wg-quick-wg0.service; then
    OPT_TOGGLE="🔒  Disconnect WireGuard (wg0)"
else
    OPT_TOGGLE="🛡️  Connect WireGuard (wg0)"
fi

if [[ -n "$PORT" && "$PORT" != "N/A" ]]; then
    OPT_PORT="🔌  Copy Forwarded Port ($PORT)"
else
    OPT_PORT="🔌  No Forwarded Port Active"
fi
OPT_PUB="🌐  Copy Public IP ($PUB_IP)"
OPT_LOC="📍  Copy Location (${COUNTRY:-N/A} - $PUB_IP)"
OPT_REFRESH="🔄  Refresh Network Status"

CHOICE=$(printf "%s\n%s\n%s\n%s\n%s" "$OPT_TOGGLE" "$OPT_PORT" "$OPT_PUB" "$OPT_LOC" "$OPT_REFRESH" | rofi -dmenu \
    -p "⚡ NETWORK & VPN MANAGER" \
    -theme-str '
      window {
        width: 380px;
        border-radius: 14px;
        border: 2px;
        border-color: #7aa2f7;
        background-color: #1a1b26;
        padding: 12px;
      }
      mainbox { background-color: transparent; }
      inputbar {
        background-color: #16161e;
        border-radius: 8px;
        padding: 8px;
        margin: 0 0 10px 0;
        children: [ prompt ];
      }
      prompt {
        text-color: #7aa2f7;
        font: "JetBrainsMono Nerd Font Bold 11";
      }
      listview {
        lines: 5;
        background-color: transparent;
        spacing: 6px;
      }
      element {
        padding: 8px 12px;
        border-radius: 8px;
        background-color: #16161e;
        text-color: #c0caf5;
      }
      element selected {
        background-color: #7aa2f7;
        text-color: #15161e;
      }
      element-text {
        background-color: transparent;
        text-color: inherit;
        font: "JetBrainsMono Nerd Font 10";
      }
    ')

case "$CHOICE" in
    *"WireGuard"*)
        toggle_wg
        ;;
    *"Copy Forwarded Port"*)
        if [[ -n "$PORT" && "$PORT" != "N/A" ]]; then
            echo -n "$PORT" | wl-copy
            notify -u normal -a "Network" "⚡ PORT COPIED" "VPN Port $PORT copied to clipboard!"
        fi
        ;;
    *"Copy Public IP"*)
        if [[ -n "$PUB_IP" && "$PUB_IP" != "N/A" && "$PUB_IP" != "Offline" && "$PUB_IP" != "Connecting..." ]]; then
            echo -n "$PUB_IP" | wl-copy
            notify -u normal -a "Network" "🌐 IP COPIED" "Public IP $PUB_IP copied to clipboard!"
        fi
        ;;
    *"Copy Location"*)
        if [[ -n "$COUNTRY" || -n "$PUB_IP" ]]; then
            echo -n "${COUNTRY:-Unknown} ($PUB_IP)" | wl-copy
            notify -u normal -a "Network" "📍 LOCATION COPIED" "${COUNTRY:-Unknown} ($PUB_IP) copied to clipboard!"
        fi
        ;;
    *"Refresh Network Status"*)
        pkill -RTMIN+8 waybar 2>/dev/null
        notify -u low -a "Network" "🔄 REFRESHED" "Network status refreshed!"
        ;;
esac
