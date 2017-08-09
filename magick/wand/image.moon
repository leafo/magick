
ffi = require "ffi"
import lib, can_resize, get_filter from require "magick.wand.lib"
import composite_operators, gravity, orientation, interlace from require "magick.wand.data"

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

  get_width: => lib.MagickGetImageWidth @wand
  get_height: => lib.MagickGetImageHeight @wand
  get_format: =>
    format = lib.MagickGetImageFormat(@wand)
    with ffi.string(format)\lower!
      lib.MagickRelinquishMemory format

  set_format: (format) =>
    handle_result @,
      lib.MagickSetImageFormat @wand, format

  get_depth: =>
    tonumber lib.MagickGetImageDepth @wand

  set_depth: (d) =>
    handle_result @,
      lib.MagickSetImageDepth @wand, d

  get_quality: => lib.MagickGetImageCompressionQuality @wand
  set_quality: (quality) =>
    handle_result @,
      lib.MagickSetImageCompressionQuality @wand, quality

  get_option: (magick, key) =>
    format = magick .. ":" .. key
    option_str = lib.MagickGetOption(@wand, format)
    with ffi.string option_str
      lib.MagickRelinquishMemory option_str

  set_option: (magick, key, value) =>
    format = magick .. ":" .. key
    handle_result @,
      lib.MagickSetOption @wand, format, value

  get_gravity: =>
    gravity\to_str lib.MagickGetImageGravity @wand

  set_gravity: (gtype) =>
    gtype = assert gravity\to_int(gtype), "invalid gravity type"
    lib.MagickSetImageGravity @wand, gtype

  strip: =>
     lib.MagickStripImage @wand

  clone: =>
    wand = ffi.gc lib.CloneMagickWand(@wand), lib.DestroyMagickWand
    Image wand, @path

  coalesce: =>
    @wand = ffi.gc lib.MagickCoalesceImages(@wand), ffi.DestroyMagickWand
    true

  resize: (w,h, f="Lanczos2", blur=1.0) =>
    error "Failed to load filter list, can't resize" unless can_resize
    w, h = @_keep_aspect w,h
    handle_result @,
      lib.MagickResizeImage @wand, w, h, get_filter(f), blur

  adaptive_resize: (w,h) =>
    w, h = @_keep_aspect w,h
    handle_result @,
      lib.MagickAdaptiveResizeImage @wand, w, h

  scale: (w,h) =>
    w, h = @_keep_aspect w,h
    handle_result @,
      lib.MagickScaleImage @wand, w, h

  crop: (w,h, x=0, y=0) =>
    handle_result @,
      lib.MagickCropImage @wand, w, h, x, y

  blur: (sigma, radius=0) =>
    handle_result @,
      lib.MagickBlurImage @wand, radius, sigma

  modulate: (brightness=100, saturation=100, hue=100) =>
    handle_result @,
      lib.MagickModulateImage @wand, brightness, saturation, hue

  sharpen: (sigma, radius=0) =>
    handle_result @,
      lib.MagickSharpenImage @wand, radius, sigma

  rotate: (degrees, r=0, g=0, b=0) =>
    pixel = ffi.gc lib.NewPixelWand!, lib.DestroyPixelWand

    lib.PixelSetRed pixel, r
    lib.PixelSetGreen pixel, g
    lib.PixelSetBlue pixel, b

    res = { handle_result @, lib.MagickRotateImage @wand, pixel, degrees }
    unpack res

  composite: (blob, x, y, op="OverCompositeOp") =>
    if type(blob) == "table" and blob.__class == Image
      blob = blob.wand

    op = assert composite_operators\to_int(op), "invalid operator type"
    handle_result @,
      lib.MagickCompositeImage @wand, blob, op, x, y

  get_blob: =>
    len = ffi.new "size_t[1]", 0
    blob = ffi.gc lib.MagickGetImageBlob(@wand, len),
      lib.MagickRelinquishMemory

    ffi.string blob, len[0]

  write: (fname) =>
    handle_result @, lib.MagickWriteImage @wand, fname

  destroy: =>
    if @wand
      lib.DestroyMagickWand ffi.gc @wand, nil
      @wand = nil

    if @pixel_wand
      lib.DestroyPixelWand ffi.gc @pixel_wand, nil
      @pixel_wand = nil

  get_pixel: (x,y) =>
    @pixel_wand or= ffi.gc lib.NewPixelWand!, lib.DestroyPixelWand
    assert lib.MagickGetImagePixelColor(@wand, x,y, @pixel_wand),
      "failed to get pixel"

    lib.PixelGetRed(@pixel_wand), lib.PixelGetGreen(@pixel_wand), lib.PixelGetBlue(@pixel_wand), lib.PixelGetAlpha(@pixel_wand)

  transpose: =>
    handle_result @, lib.MagickTransposeImage @wand

  transverse: =>
    handle_result @, lib.MagickTransverseImage @wand

  flip: =>
    handle_result @, lib.MagickFlipImage @wand

  flop: =>
    handle_result @, lib.MagickFlopImage @wand

  get_property: (property) =>
    res = lib.MagickGetImageProperty @wand, property
    if nil != res
      with ffi.string res
        lib.MagickRelinquishMemory res
    else
      code, msg = get_exception @wand
      nil, msg, code

  set_property: (property, value) =>
    handle_result @,
      lib.MagickSetImageProperty @wand, property, value

  get_orientation: =>
    orientation\to_str lib.MagickGetImageOrientation @wand

  set_orientation: (otype) =>
    otype = assert orientation\to_int(otype), "invalid orientation type"
    lib.MagickSetImageOrientation @wand, otype

  get_interlace_scheme: =>
    interlace\to_str lib.MagickGetImageInterlaceScheme @wand

  set_interlace_scheme: (itype) =>
    itype = assert interlace\to_int(itype), "invalid interlace type"
    lib.MagickSetImageInterlaceScheme @wand, itype

  auto_orient: =>
    handle_result @, lib.MagickAutoOrientImage @wand

  reset_page: =>
    handle_result @, lib.MagickResetImagePage @wand, nil

  extent: (w, h, x, y) =>
    handle_result @,
      lib.MagickExtentImage @wand, w, h, x, y

  __tostring: =>
    "Image<#{@path}, #{@wand}>"

{ :Image }
