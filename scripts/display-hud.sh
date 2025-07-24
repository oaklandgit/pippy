#!/bin/bash

USER=$(whoami)
DEVICE=$(hostname)

if [[ "$OSTYPE" == "darwin"* ]]; then
  LOCAL_IP=$(ipconfig getifaddr en0)
else
  LOCAL_IP=$(hostname -I | awk '{print $1}')
fi

PUBLIC_IP=$(curl -s https://ifconfig.me)

echo "${USER}@${DEVICE}"
echo "Local IP: $LOCAL_IP"
echo "Public IP: $PUBLIC_IP"

