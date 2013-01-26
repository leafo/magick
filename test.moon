
import load_image from require "magick"

img = load_image "hi.png"
img\resize 600,600
print img

blob = img\get_blob!
print #blob

