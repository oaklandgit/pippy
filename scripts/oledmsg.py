#!/usr/bin/env python3

import sys
import time
import Adafruit_SSD1306
from PIL import Image, ImageDraw, ImageFont

# --- Argument Parsing ---
args = sys.argv[1:]
duration = None
lines = []

i = 0
while i < len(args):
    if args[i] in ("-d", "--duration"):
        i += 1
        if i < len(args):
            try:
                duration = float(args[i])
            except ValueError:
                print("Invalid duration:", args[i])
                sys.exit(1)
        else:
            print("Missing value for -d")
            sys.exit(1)
    else:
        lines.append(args[i])
    i += 1

# If input is piped, override with stdin
if not sys.stdin.isatty():
    lines = [line.strip() for line in sys.stdin if line.strip()]

# --- OLED Setup ---
disp = Adafruit_SSD1306.SSD1306_128_64(rst=None)
disp.begin()
disp.clear()
disp.display()

width, height = disp.width, disp.height
image = Image.new('1', (width, height))
draw = ImageDraw.Draw(image)
font = ImageFont.load_default()
line_height = 10
max_lines = height // line_height
lines = lines[:max_lines]

# --- Drawing ---
draw.rectangle((0, 0, width, height), fill=0)
for i, line in enumerate(lines):
    y = i * line_height
    draw.text((0, y), line, font=font, fill=255)

disp.image(image)
disp.display()

# --- Duration ---
if duration is not None:
    time.sleep(duration)
    disp.clear()
    disp.display()