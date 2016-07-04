
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

