
ffi = require "ffi"
import lib from require "magick.gmwand.lib"

get_exception = (wand) ->
  etype = ffi.new "ExceptionType[1]", 0
  msg = ffi.string ffi.gc lib.MagickGetException(wand, etype), lib.MagickRelinquishMemory
  etype[0], msg

class Image extends require "magick.base_image"
  @load: (path) =>
    wand = ffi.gc lib.NewMagickWand!, lib.DestroyMagickWand
    if 0 == lib.MagickReadImage wand, path
      code, msg = get_exception wand
      return nil, msg, code

    @ wand, path

  @load_from_blob: (blob) =>

  new: (@wand, @path) =>

  get_width: => tonumber lib.MagickGetImageWidth @wand
  get_height: => tonumber lib.MagickGetImageHeight @wand

  __tostring: =>
    "GMImage<#{@path}, #{@wand}>"

{:Image}
