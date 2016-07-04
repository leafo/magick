
magick = require "magick.gmwand"

describe "magick", ->
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


  describe "with image", ->
    import load_image, load_image_from_blob from magick
    out_path = (fname) -> "spec_gm/output_images/#{fname}"

    local img

    before_each ->
      img = assert load_image "spec/test_image.png"

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

