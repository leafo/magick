
ffi = require "ffi"
import lib from require "magick.gmwand.lib"

class Image extends require "magick.base_image"
  @load: (path) =>
    wand = ffi.gc lib.NewMagickWand!, lib.DestroyMagickWand
    if 0 == lib.MagickReadImage wand, path
      return nil, "failed to load image"

    @ wand, path

  @load_from_blob: (blob) =>

  new: (@wand, @path) =>

  get_width: => tonumber lib.MagickGetImageWidth @wand
  get_height: => tonumber lib.MagickGetImageHeight @wand

  __tostring: =>
    "GMImage<#{@path}, #{@wand}>"

{:Image}
