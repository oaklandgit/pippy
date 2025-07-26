import board
import neopixel

pixels = neopixel.NeoPixel(board.D18, 8, brightness=0.5, auto_write=True)
pixels.fill((0, 0, 255))  # blue
