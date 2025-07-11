#!/bin/bash
set -e

echo "Enabling USB Gadget Mode with dual interface support (usb0 + wlan0)..."

# 1. Enable dwc2 overlay in /boot/config.txt
CONFIG="/boot/firmware/config.txt"
if ! grep -q "^dtoverlay=dwc2" "$CONFIG"; then
  echo "Adding dtoverlay=dwc2 to $CONFIG"
  echo "dtoverlay=dwc2" | sudo tee -a "$CONFIG" > /dev/null
else
  echo "dtoverlay=dwc2 already set"
fi

# 2. Add dwc2 and g_ether to /boot/cmdline.txt
CMDLINE="/boot/firmware/cmdline.txt"
if ! grep -q "modules-load=dwc2,g_ether" "$CMDLINE"; then
  echo "Patching $CMDLINE to load dwc2 and g_ether..."
  sudo sed -i 's/rootwait/rootwait modules-load=dwc2,g_ether/' "$CMDLINE"
else
  echo "modules-load already present in $CMDLINE"
fi

# 3. Configure /etc/dhcpcd.conf for usb0 and wlan0
DHCPCD="/etc/dhcpcd.conf"
if ! grep -q "interface usb0" "$DHCPCD"; then
  echo "Adding static IP config for usb0 and routing preference for wlan0..."
  cat <<EOF | sudo tee -a "$DHCPCD" > /dev/null

interface usb0
    static ip_address=192.168.2.2/24
    static routers=192.168.2.1
    static domain_name_servers=192.168.2.1 8.8.8.8
    metric 300

interface wlan0
    metric 100
EOF
else
  echo "usb0 and wlan0 config already exists in $DHCPCD"
fi

echo "Gadget mode networking setup complete. Please reboot to apply changes."