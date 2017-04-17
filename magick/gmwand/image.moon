
ffi = require "ffi"
import lib from require "magick.gmwand.lib"
data = require "magick.gmwand.data"

get_exception = (wand) ->
  etype = ffi.new "ExceptionType[1]", 0
  msg = ffi.string ffi.gc lib.MagickGetException(wand, etype), lib.MagickRelinquishMemory
  etype[0], msg


handle_result = (img_or_wand, status) ->
  wand = img_or_wand.wand or img_or_wand
  if status == 0
    code, msg = get_exception wand
    nil, msg, code
  else
    true

class Image extends require "magick.base_image"
  @load: (path) =>
    wand = ffi.gc lib.NewMagickWand!, lib.DestroyMagickWand
    if 0 == lib.MagickReadImage wand, path
      code, msg = get_exception wand
      return nil, msg, code

    @ wand, path

  @load_from_blob: (blob) =>
    wand = ffi.gc lib.NewMagickWand!, lib.DestroyMagickWand
    if 0 == lib.MagickReadImageBlob wand, blob, #blob
      code, msg = get_exception wand
      return nil, msg, code

    @ wand, "<from_blob>"

  new: (@wand, @path) =>

  get_width: => tonumber lib.MagickGetImageWidth @wand
  get_height: => tonumber lib.MagickGetImageHeight @wand

  clone: =>
    wand = ffi.gc lib.CloneMagickWand(@wand), lib.DestroyMagickWand
    Image wand, @path

  resize: (w,h, filter="Lanczos", blur=1.0) =>
    filter = assert data.filters\to_int(filter .. "Filter"), "invalid filter"
    w, h = @_keep_aspect w,h
    handle_result @, lib.MagickResizeImage @wand, w, h, filter, blur

  scale: (w,h) =>
    w, h = @_keep_aspect w,h
    handle_result @, lib.MagickScaleImage @wand, w, h

  crop: (w,h, x=0, y=0) =>
    handle_result @, lib.MagickCropImage @wand, w, h, x, y

  blur: (sigma, radius=0) =>
    handle_result @,
      lib.MagickBlurImage @wand, radius, sigma

  modulate: (brightness=100, saturation=100, hue=100) =>
    handle_result @,
      lib.MagickModulateImage @wand, brightness, saturation, hue

  write: (fname) =>
    handle_result @, lib.MagickWriteImage @wand, fname

  composite: (blob, x, y, op="OverCompositeOp") =>
    if type(blob) == "table" and blob.__class == Image
      blob = blob.wand

    op = assert data.composite_operators\to_int(op), "invalid operator type"
    handle_result @,
      lib.MagickCompositeImage @wand, blob, op, x, y

  get_blob: =>
    len = ffi.new "size_t[1]", 0
    blob = ffi.gc lib.MagickWriteImageBlob(@wand, len),
      lib.MagickRelinquishMemory

    ffi.string blob, len[0]

  reset_page: =>
    lib.MagickSetImagePage @wand, @get_width!, @get_height!, 0, 0

  __tostring: =>
    "GMImage<#{@path}, #{@wand}>"

{:Image}
