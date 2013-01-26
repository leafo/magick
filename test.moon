
import load_image from require "magick"

do
  img = load_image "hi.png"
  img\resize_and_crop 500,1000
  img\write "out.png"
