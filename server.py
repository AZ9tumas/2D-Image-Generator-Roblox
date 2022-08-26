from PIL import Image

# Read from a file
pixel_data = open("pixinfo.txt", "r")
lines = pixel_data.readlines()

print(len(lines))

MAX_X = 720#1600
MAX_Y = 720#900

img = Image.new("RGB", (MAX_X, MAX_Y))

x = 0
y = 0


for i in lines:
    if y >= MAX_Y:
        y = 0
        x += 1
    r, g, b = i.split(" ")
    
    img.putpixel((x, y), (int(float(r)), int(float(g)), int(float(b))))
    y += 1


img.save("test3.png")

pixel_data.close()