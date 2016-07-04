
magick = require "magick.gmwand"

describe "magick", ->
  it "has a version", ->
    assert.truthy magick.VERSION
