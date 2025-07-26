#!/bin/bash
CONFIG="/boot/config.txt"

# Enable pwm-2chan overlay
echo "Setting up neopixels..."
if ! grep -q "^dtoverlay=pwm-2chan" "$CONFIG"; then
  echo "Adding dtoverlay=pwm-2chan to $CONFIG"
  echo "dtoverlay=pwm-2chan" | sudo tee -a "$CONFIG" > /dev/null
else
  echo "dtoverlay=pwm-2chan already set"
fi
echo "Finished setting up neopixels."
