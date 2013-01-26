
import load_image from require "magick"

do
  img = load_image "hi.png"
  img\resize 600,600
  img\write "resized.png"

do
  img = load_image "hi.png"
  img\adaptive_resize 600,600
  img\write "adaptive.png"

