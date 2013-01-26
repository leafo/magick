
import load_image, load_image_from_blob from require "magick"

switch ...
  when "resize"
    img = load_image "hi.png"
    img\resize nil, 80
    img\write "out.png"

  when "resize2"
    img = load_image "hi.png"
    img\resize_and_crop 500,1000
    img\write "out.png"

  when "blur"
    img = load_image "hi.png"
    img\blur 3, 10
    img\write "out.png"

  when "clone"
    img = load_image "hi.png"
    img2 = img\clone!
    img2\resize 50, 50

    print "first: #{img\get_width!}, #{img\get_height!}"
    print "second: #{img2\get_width!}, #{img2\get_height!}"

  when "blob"
    img = load_image "hi.png"
    blob = img\get_blob!

    img2 = load_image_from_blob blob
    print img2, img2\get_width!, img2\get_height!

  else
    error "don't know what to do"
