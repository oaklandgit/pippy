#!/usr/bin/env python3

# NOTE: Must be run as root
import board
import neopixel
import sys

NUM_PIXELS = 8 # number of pixels
pixels = neopixel.NeoPixel(board.D18, NUM_PIXELS, brightness=0.5, auto_write=False)

# if 3 args, set all pixels
if len(sys.argv) == 4:
    r, g, b = map(int, sys.argv[1:4])
    for i in range(NUM_PIXELS):
        pixels[i] = (r, g, b)

# if 4 args, set a single pixel
elif len(sys.argv) == 5:
    idx = int(sys.argv[1])
    r, g, b = map(int, sys.argv[2:5])
    if 0 <= idx < NUM_PIXELS:
        pixels[idx] = (r, g, b)
    else:
        print(f"Pixel index must be 0-{NUM_PIXELS - 1}")
        sys.exit(1)
else:
    print("Usage:")
    print("  neopixel-set.py R G B        # set all")
    print("  neopixel-set.py IDX R G B    # set one")
    sys.exit(1)

pixels.show()
