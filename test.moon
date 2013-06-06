
import load_image, load_image_from_blob, thumb from require "magick"

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

  when "thumb"
    thumb "hi.png", "150x200", "out.png"
    thumb "hi.png", "150x200#", "out2.png"

  when "format"
    img = load_image "hi.png"
    print img\set_format "bmp"
    print img\get_format!

  when "set_quality"
    img = load_image "hi.png"
    img\set_quality 90
    img\write "out.png"

  when "get_quality"
    img = load_image "hi.png"
    img\set_quality 90
    print "quality of hi.png is #{img\get_quality()}"

  when "sharpen"
    img = load_image "hi.png"
    img\sharpen 1
    img\write "out.png"

  else
    error "don't know what to do"
