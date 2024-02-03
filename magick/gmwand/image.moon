
cffi = require "cffi"
import lib from require "magick.gmwand.lib"
data = require "magick.gmwand.data"

get_exception = (wand) ->
  etype = cffi.new "ExceptionType[1]", 0
  msg = cffi.string cffi.gc lib.MagickGetException(wand, etype), lib.MagickRelinquishMemory
  etype[0], msg


handle_result = (img_or_wand, status) ->
  wand = img_or_wand.wand or img_or_wand
  if status == 0
    code, msg = get_exception wand
    nil, msg, code
  else
    true

class Image extends require "magick.base_image"
  @blank_image: (width, height, fill="none") =>
    wand = cffi.gc lib.NewMagickWand!, lib.DestroyMagickWand

    if 0 == lib.MagickSetSize wand, width, height
      code, msg = get_exception wand
      return nil, msg, code

    if fill
      -- this will fill the image with an initial image, transparent with the default `none`
      -- set to false to make a wand with no images in it
      -- example values:
      -- "#00FF00FF" for transparent green
      -- "red" for solid red
      if 0 == lib.MagickReadImage wand, "xc:#{fill}"
        code, msg = get_exception wand
        return nil, msg, code

    @ wand, "<blank_image>"

  @load: (path) =>
    wand = cffi.gc lib.NewMagickWand!, lib.DestroyMagickWand
    if 0 == lib.MagickReadImage wand, path
      code, msg = get_exception wand
      return nil, msg, code

    @ wand, path

  @load_from_blob: (blob) =>
    wand = cffi.gc lib.NewMagickWand!, lib.DestroyMagickWand
    if 0 == lib.MagickReadImageBlob wand, blob, #blob
      code, msg = get_exception wand
      return nil, msg, code

    @ wand, "<from_blob>"

  new: (@wand, @path) =>

  get_width: => cffi.tonumber lib.MagickGetImageWidth @wand
  get_height: => cffi.tonumber lib.MagickGetImageHeight @wand

  get_format: =>
    format = lib.MagickGetImageFormat(@wand)
    if format == nil
      return nil

    with cffi.string(format)\lower!
      lib.MagickRelinquishMemory format

  set_format: (format) =>
    handle_result @,
      lib.MagickSetImageFormat @wand, format

  get_depth: =>
    cffi.tonumber lib.MagickGetImageDepth @wand

  set_depth: (d) =>
    handle_result @,
      lib.MagickSetImageDepth @wand, d

  clone: =>
    wand = cffi.gc lib.CloneMagickWand(@wand), lib.DestroyMagickWand
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

  sharpen: (sigma, radius=0) =>
    handle_result @,
      lib.MagickSharpenImage @wand, radius, sigma

  set_quality: (quality) =>
    handle_result @,
      lib.MagickSetCompressionQuality @wand, quality

  get_blob: =>
    len = cffi.new "size_t[1]", 0
    blob = cffi.gc lib.MagickWriteImageBlob(@wand, len),
      lib.MagickRelinquishMemory

    cffi.string blob, len[0]

  get_colorspace: =>
    out = lib.MagickGetImageColorspace @wand
    data.colorspaces\to_str cffi.tonumber out

  set_colorspace: (colorspace) =>
    colorspace = assert data.colorspaces\to_int(colorspace), "invalid operator type"
    handle_result @, lib.MagickSetImageColorspace @wand, colorspace

  -- redirect method for old name
  level_image: (...) => @level ...

  -- this method is broken in graphics magic, arguments are swapped in C
  level: (black, gamma, white) =>
    handle_result @, lib.MagickLevelImage @wand, black, gamma, white

  hald_clut: (clut_wand) =>
    if type(clut_wand) == "table" and clut_wand.__class == Image
      clut_wand = clut_wand.wand

    handle_result @, lib.MagickHaldClutImage @wand, clut_wand

  auto_orient: =>
    handle_result @, lib.MagickAutoOrientImage @wand, 0

  reset_page: =>
    lib.MagickSetImagePage @wand, @get_width!, @get_height!, 0, 0

  __tostring: =>
    "GMImage<#{@path}, #{@wand}>"

{:Image}
