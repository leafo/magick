
ffi = require "ffi"
import lib from require "magick.gmwand.lib"
data = require "magick.gmwand.data"

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

  resize: (w,h, filter="Lanczos", blur=1.0) =>
    filter = assert data.filters\to_int(filter), "invalid filter"
    w, h = @_keep_aspect w,h
    handle_result @,
      lib.MagickResizeImage @wand, w, h, filter, blur

  scale: (w,h) =>
    w, h = @_keep_aspect w,h
    handle_result @,
      lib.MagickScaleImage @wand, w, h

  crop: (w,h, x=0, y=0) =>
    handle_result @,
      lib.MagickCropImage @wand, w, h, x, y

  __tostring: =>
    "GMImage<#{@path}, #{@wand}>"

{:Image}
