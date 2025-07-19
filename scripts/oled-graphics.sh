import Adafruit_SSD1306
from PIL import Image, ImageDraw, ImageFont
import time

# Init display
disp = Adafruit_SSD1306.SSD1306_128_64(rst=None)
disp.begin()
disp.clear()
disp.display()

# Create a blank image for drawing
width = disp.width
height = disp.height
image = Image.new('1', (width, height))
draw = ImageDraw.Draw(image)

# Draw a rectangle border
draw.rectangle((0, 0, width-1, height-1), outline=255, fill=0)

# Draw a filled ellipse
draw.ellipse((10, 10, 30, 30), outline=255, fill=255)

# Draw a line
draw.line((0, height//2, width, height//2), fill=255)

# Draw some text
font = ImageFont.load_default()
draw.text((40, 15), "Graphics!", font=font, fill=255)

# Show it
disp.image(image)
disp.display()

# Leave it on screen
time.sleep(10)
disp.clear()
disp.display()