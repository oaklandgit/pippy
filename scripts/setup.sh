#!/bin/bash
set -e

echo "Setting up Pippy!"

./00-configure-network.sh
./01-setup-apps.sh
./02-configure-oled.sh
./03-configure-sessions.sh
./04-configure-neopixels.sh
echo "Done!"
