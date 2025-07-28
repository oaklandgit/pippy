#!/usr/bin/env python3

# NOTE: Must be run as root
import board
import neopixel
import sys

n = 8 # number of pixels
pixels = neopixel.NeoPixel(board.D18, n, brightness=0.5, auto_write=False)

color = tuple(map(int, sys.argv[1:4])) # expects RGB
for i in range(n):
    pixels[i] = color
pixels.show()
