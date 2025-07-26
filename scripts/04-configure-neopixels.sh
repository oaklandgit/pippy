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

echo "Done setting up pwm-2chan overlay. But won't work until you reboot."

# Install NeoPixel libraries system-wide.
# These need to run as root because they use /dev/mem for PWM access,
# so we install them with sudo to make them available to scripts that run with sudo.
echo "Installing neopixel python library..."
sudo pip3 install --upgrade rpi_ws281x adafruit-circuitpython-neopixel adafruit-blinka
sudo pip3 install rpi_ws281x adafruit-circuitpython-neopixel

echo "Done setting up neopixels."
