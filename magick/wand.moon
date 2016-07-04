
ffi = require "ffi"
import lib, can_resize from require "magick.wand.lib"

lib.MagickWandGenesis!

import Image from require "magick.wand.image"

{
  mode: "image_magick"
  :Image
  load_image: Image\load
  load_image_from_blob: Image\load_from_blob
}
