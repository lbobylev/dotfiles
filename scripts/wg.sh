#!/usr/bin/env bash

WG_CONFIG="/Users/leonid/wg0.conf"

get_current_location() {
    curl -s4 ifconfig.me/ip
}

case "$1" in
  up)
    sudo wg-quick up "$WG_CONFIG"
    echo "VPN поднят ✅"
    echo "Текущий IP: $(get_current_location)"
    ;;
  down)
    sudo wg-quick down "$WG_CONFIG"
    echo "VPN остановлен ⛔"
    echo "Текущий IP: $(get_current_location)"
    ;;
  status)
    if wg show 2>/dev/null | grep -q interface; then
      echo "VPN активен 🟢"
      echo "Текущий IP: $(get_current_location)"
    else
      echo "VPN выключен 🔴"
      echo "Текущий IP: $(get_current_location)"
    fi
    ;;
  *)
    echo "Использование: $0 {up|down|status}"
    exit 1
    ;;
esac
