import lib from require "magick.gmwand.lib"

lib.InitializeMagick nil

import Image from require "magick.gmwand.image"
import make_thumb from require "magick.thumb"

load_image = Image\load

{
  VERSION: require "magick.version"
  mode: "graphics_magick"

  :Image
  :load_image

  thumb: make_thumb load_image
  load_image_from_blob: Image\load_from_blob
}
