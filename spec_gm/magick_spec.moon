
magick = require "magick.gmwand"

describe "magick", ->
  out_path = (fname) -> "spec_gm/output_images/#{fname}"

  it "has a version", ->
    assert.truthy magick.VERSION

  describe "image", ->
    import load_image, load_image_from_blob from magick

    it "loads an image", ->
      image = assert load_image "spec/test_image.png"
      assert.same 64, image\get_width!
      assert.same 64, image\get_height!

    it "handles image that doesn't exist", ->
      img, err = load_image "spec/doesntexis.png"
      assert.nil img
      assert.same "Unable to open file (spec/doesntexis.png)", err

    it "loads blob", ->
      blob = io.open("spec/test_image.png")\read "*a"
      image = load_image_from_blob blob

      assert.same 64, image\get_width!
      assert.same 64, image\get_height!

    it "creates blank image", ->
      image = magick.Image\blank_image 120, 20

      assert.same 120, image\get_width!
      assert.same 20, image\get_height!

      assert image\write out_path "blank_transparent.png"

    it "creates blank image with color", ->
      image = magick.Image\blank_image 145, 88, "red"

      assert.same 145, image\get_width!
      assert.same 88, image\get_height!

      assert image\write out_path "blank_red.jpg"

  describe "with image", ->
    import load_image, load_image_from_blob from magick

    local img

    before_each ->
      img = assert load_image "spec/test_image.png"

    it "get_blob", ->
      blob = assert img\get_blob!
      reloaded = load_image_from_blob blob

      assert.same 64, reloaded\get_width!
      assert.same 64, reloaded\get_height!

    it "resize", ->
      assert img\resize nil, 80
      assert img\write out_path "resize.png"

    it "crop", ->
      assert img\crop 20, 20
      assert img\write out_path "crop.png"

    it "scale", ->
      assert img\scale 80
      assert img\write out_path "scale.png"

    it "resize_and_crop", ->
      assert img\resize_and_crop 500,1000
      assert img\write out_path "resize_and_crop.png"

    it "blur", ->
      assert img\blur 3, 10
      assert img\write out_path "blur.png"

    it "sharpen", ->
      assert img\sharpen 3, 10
      assert img\write out_path "sharp.png"

    it "scale", ->
      assert img\scale 80
      assert img\write out_path "scale.png"

    it "composite", ->
      img2 = img\clone!
      assert img2\resize 32
      assert img\composite img2, 10, 20
      assert img\write out_path "composite.png"

    it "modulate", ->
      img2 = img\clone!
      assert img2\modulate 50, 50, 50
      assert img2\write out_path "modulate.png"

    it "gets format", ->
      assert.same "png", img\get_format!

    it "sets format", ->
      img2 = img\clone!
      img2\set_format "bmp"
      assert.same "bmp", img2\get_format!
      assert img\write out_path "b.bmp"

    it "repage", ->
      img2 = img\clone!
      img2\crop 10, 10, 10, 10
      img2\reset_page!

    it "gets depth", ->
      d = img\get_depth!
      assert.same 8, d

    it "sets depth", ->
      img2 = img\clone!
      img2\set_depth 16


