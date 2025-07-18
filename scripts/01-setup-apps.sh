#!/bin/bash
set -e

echo "Uninstalling unused apps..."

# Even though Chromium is installed on Raspberry Pi OS by default,
# it doesn't actually work on the Pi Zero.
# So we're replacing it with Midori.

echo "Removing Chromium..."
sudo apt remove --purge -y chromium-browser chromium
sudo apt autoremove -y
echo "Chromium removed."

echo "Installing Midori..."
sudo apt install -y midori
echo "Midori installed."
