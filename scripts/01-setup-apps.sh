#!/bin/bash
set -e

echo "Uninstalling unused apps..."

echo "Removing Chromium..."
sudo apt remove --purge -y chromium-browser chromium
sudo apt autoremove -y
echo "Chromium removed."

echo "Installing Midori..."
sudo apt install -y midori
echo "Midori installed."