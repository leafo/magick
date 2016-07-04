
ffi = require "ffi"
import lib, can_resize from require "magick.wand.lib"

lib.MagickWandGenesis!

import Image from require "magick.wand.image"
import make_thumb from require "magick.thumb"

load_image = Image\load

{
  VERSION: require "magick.version"
  mode: "image_magick"

  :Image
  :load_image

  thumb: make_thumb load_image
  load_image_from_blob: Image\load_from_blob
}
