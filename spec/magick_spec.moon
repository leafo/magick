
magick = require "magick"

describe "magick", ->
  describe "parse_size_str", ->
    import parse_size_str from magick
    src_w, src_h = 500, 300

    tests = {
      {"10x10", {w: 10}}
      {"50%x50%", {h: 150}}
      {"50%x50%!", {w: 250, h: 150}}
      {"x10", {h: 10}}
      {"10x%", {w: 10}}
      {"10x10%#", {w: 10, h: 30, center_crop: true}}

      {"200x300", {w: 200}}
      {"200x300!", {w: 200, h: 300}}
      {"200x300+10+20", {w: 200, h: 300, crop_x: 10, crop_y: 20}}
    }

    for {size_str, expected} in *tests
      it "should parse size string correctly", ->
        assert.same expected, parse_size_str size_str, src_w, src_h

  describe "image", ->
    import load_image, load_image_from_blob from magick
    out_path = (fname) -> "spec/output_images/#{fname}"

    local img

    before_each ->
      img = assert load_image "spec/test_image.png"

    after_each ->
      img\destroy!
      img = nil

    it "icon", ->
      img\resize 16, 16
      img\write out_path "icon.ico"

    it "resize", ->
      img\resize nil, 80
      img\write out_path "resize.png"

    it "resize_and_crop", ->
      img\resize_and_crop 500,1000
      img\write out_path "resize_and_crop.png"

    it "blur", ->
      img\blur 3, 10
      img\write out_path "blur.png"

    it "quality", ->
      img\set_quality 50
      assert.same 50, img\get_quality!
      img\write out_path "quality.jpg"

    it "sharpen", ->
      img\sharpen 1
      img\write out_path "sharpen.png"

    it "scale", ->
      img\scale 80
      img\write out_path "scale.png"

    it "composite", ->
      img2 = img\clone!
      img2\resize 32

      assert img\composite img2, 10, 20

      img\write out_path "composite.png"
      img2\destroy!

    it "should make clone", ->
      before_w, before_h = img\get_width!, img\get_height!
      cloned = img\clone!
      cloned\resize 50, 20

      assert.same before_w, img\get_width!
      assert.same before_h, img\get_height!

      assert.same 50, cloned\get_width!
      assert.same 20, cloned\get_height!

      cloned\destroy!

    it "should return blob", ->
      blob = img\get_blob!
      blob_img = load_image_from_blob blob

      assert.same img\get_width!, blob_img\get_width!
      assert.same img\get_height!, blob_img\get_height!

      blob_img\destroy!

    it "should set format", ->
      img\set_format "bmp"
      assert.same "bmp", img\get_format!

    it "should set gravity", ->
      img\set_gravity "SouthEastGravity"
      assert.same "SouthEastGravity", img\get_gravity!

    it "should set option", ->
      img\set_option "webp", "lossless", "0"
      assert.same "0", img\get_option "webp", "lossless"

  describe "color_image", ->
    import load_image from magick
    local img

    before_each ->
      img = assert load_image "spec/color_test.png"

    after_each ->
      img\destroy!
      img = nil

    it "should get colors of pixels", ->
      local r,g,b,a
      assert_bytes = (er,eg,eb,ea) ->
        assert.same er, math.floor r * 255
        assert.same eg, math.floor g * 255
        assert.same eb, math.floor b * 255
        assert.same ea, math.floor a * 255

      r,g,b,a = img\get_pixel 0, 0
      assert_bytes 217, 70, 70, 255

      r,g,b,a = img\get_pixel 1, 0
      assert_bytes 152, 243, 174, 255

      r,g,b,a = img\get_pixel 1, 1
      assert_bytes 255, 240, 172, 255

      r,g,b,a = img\get_pixel 0, 1
      assert_bytes 152, 159, 243, 255


  describe "exif #exif", ->
    it "should strip exif data", ->
      import load_image, load_image_from_blob from magick
      img = load_image "spec/exif_test.jpg"
      img\strip!
      img\write "spec/output_images/exif_test.jpg"

  describe "thumb", ->
    import thumb from magick
    sizes = {
      "150x200"
      "150x200#"
      "30x30+20+20"
    }

    for i, size in ipairs sizes
      it "should create thumb for #{size}", ->
        thumb "spec/test_image.png", size,
          "spec/output_images/thumb_#{i}.png"

