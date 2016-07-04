
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


