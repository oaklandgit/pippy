#!/bin/bash

USER=$(whoami)
DEVICE=$(hostname)
DATE=$(date +%d/%m/%Y)
TIME=$(date +%H:%M)

# UPTIME
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS: use `uptime` and clean it up
  UPTIME=$(uptime | sed 's/.*up \([^,]*\), .*/\1/')
  # WIFI SIGNAL // Mac OS
  RSSI=$(wdutil info | grep 'RSSI' | awk '{print $3}')

  # Clamp RSSI between -100 (very weak) and -50 (excellent)
  if [ "$RSSI" -lt -100 ]; then
    RSSI=-100
  elif [ "$RSSI" -gt -50 ]; then
    RSSI=-50
  fi
  PERCENT=$((2 * (RSSI + 100)))  # Maps -100 to 0%, -50 to 100%
else
  # Linux: use pretty uptime if available
  UPTIME=$(uptime -p)
  PERCENT=$(awk '/wlan0/ { print int($3 * 100 / 70) }' /proc/net/wireless)
fi

# LOCAL IP
if [[ "$OSTYPE" == "darwin"* ]]; then
  LOCAL_IP=$(ipconfig getifaddr en0)
else
  LOCAL_IP=$(hostname -I | awk '{print $1}')
fi

PUBLIC_IP=$(curl -s https://ifconfig.me)

# echo "${USER}@${DEVICE}"
echo " $PERCENT%"
echo "󰌗 $LOCAL_IP"
echo " $PUBLIC_IP"
