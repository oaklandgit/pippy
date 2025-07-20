#!/bin/bash

set -e
echo "Configuring OLED display..."
# sudo apt update
sudo apt install -y python3-pil python3-numpy python3-pip i2c-tools

echo "Installing required Python libraries..."
sudo pip3 install Adafruit-GPIO Adafruit-SSD1306

echo "📝 Creating OLED test script..."

cat << 'EOF' > ~/oled-test.py
import Adafruit_SSD1306
from PIL import Image, ImageDraw, ImageFont
import time

# Initialize display
disp = Adafruit_SSD1306.SSD1306_128_64(rst=None)
disp.begin()
disp.clear()
disp.display()

# Create image buffer
image = Image.new('1', (disp.width, disp.height))
draw = ImageDraw.Draw(image)

# Draw test message
font = ImageFont.load_default()
draw.text((0, 0), "OLED WORKING", font=font, fill=255)

# Show message
disp.image(image)
disp.display()
time.sleep(10)

# Clear screen before exiting
disp.clear()
disp.display()
EOF

echo "Testing OLED display..."
python3 ~/oled-test.py

echo "Done with OLED configuration."