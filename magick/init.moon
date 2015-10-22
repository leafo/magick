
VERSION = "1.1.0"

ffi = require "ffi"

ffi.cdef [[
  typedef void MagickWand;
  typedef void PixelWand;

  typedef int MagickBooleanType;
  typedef int ExceptionType;
  typedef int ssize_t;
  typedef int CompositeOperator;
  typedef int GravityType;

  void MagickWandGenesis();
  MagickWand* NewMagickWand();
  MagickWand* DestroyMagickWand(MagickWand*);
  MagickBooleanType MagickReadImage(MagickWand*, const char*);
  MagickBooleanType MagickReadImageBlob(MagickWand*, const void*, const size_t);

  char* MagickGetException(const MagickWand*, ExceptionType*);

  int MagickGetImageWidth(MagickWand*);
  int MagickGetImageHeight(MagickWand*);

  MagickBooleanType MagickAddImage(MagickWand*, const MagickWand*);

  MagickBooleanType MagickAdaptiveResizeImage(MagickWand*, const size_t, const size_t);

  MagickBooleanType MagickWriteImage(MagickWand*, const char*);

  unsigned char* MagickGetImageBlob(MagickWand*, size_t*);

  void* MagickRelinquishMemory(void*);

  MagickBooleanType MagickCropImage(MagickWand*,
    const size_t, const size_t, const ssize_t, const ssize_t);

  MagickBooleanType MagickBlurImage(MagickWand*, const double, const double);

  MagickBooleanType MagickSetImageFormat(MagickWand* wand, const char* format);
  char* MagickGetImageFormat(MagickWand* wand);

  size_t MagickGetImageCompressionQuality(MagickWand * wand);
  MagickBooleanType MagickSetImageCompressionQuality(MagickWand *wand,
  const size_t quality);

  MagickBooleanType MagickSharpenImage(MagickWand *wand,
    const double radius,const double sigma);

  MagickBooleanType MagickScaleImage(MagickWand *wand,
    const size_t columns,const size_t rows);

  MagickBooleanType MagickRotateImage(MagickWand *wand,
  const PixelWand *background,const double degrees);

  MagickBooleanType MagickSetOption(MagickWand *,const char *,const char *);
  char* MagickGetOption(MagickWand *,const char *);

  MagickBooleanType MagickCompositeImage(MagickWand *wand,
    const MagickWand *source_wand,const CompositeOperator compose,
    const ssize_t x,const ssize_t y);

  GravityType MagickGetImageGravity(MagickWand *wand);
  MagickBooleanType MagickSetImageGravity(MagickWand *wand,
    const GravityType gravity);

  MagickBooleanType MagickStripImage(MagickWand *wand);

  MagickBooleanType MagickGetImagePixelColor(MagickWand *wand,
    const ssize_t x,const ssize_t y,PixelWand *color);

  MagickWand* MagickCoalesceImages(MagickWand*);

  PixelWand *NewPixelWand(void);
  PixelWand *DestroyPixelWand(PixelWand *);

  double PixelGetAlpha(const PixelWand *);
  double PixelGetRed(const PixelWand *);
  double PixelGetGreen(const PixelWand *);
  double PixelGetBlue(const PixelWand *);

  void PixelSetAlpha(PixelWand *wand, const double alpha);
  void PixelSetRed(PixelWand *wand, const double red);
  void PixelSetGreen(PixelWand *wand, const double green);
  void PixelSetBlue(PixelWand *wand, const double blue);
]]

get_flags = ->
  proc = io.popen "pkg-config --cflags --libs MagickWand", "r"
  flags = proc\read "*a"
  get_flags = -> flags
  proc\close!
  flags

get_filters = ->
  fname = "magick/resample.h"
  prefixes = {
    "/usr/include/ImageMagick"
    "/usr/local/include/ImageMagick"
    unpack [p for p in get_flags!\gmatch "-I([^%s]+)"]
  }

  for p in *prefixes
    full = "#{p}/#{fname}"
    if f = io.open full
      content = with f\read "*a" do f\close!
      filter_types = content\match "(typedef enum.-FilterTypes;)"
      if filter_types
        ffi.cdef filter_types
        return true

  false

try_to_load = (...) ->
  local out
  for name in *{...}
    if "function" == type name
      name = name!
      continue unless name

    return out if pcall ->
      out = ffi.load name

  error "Failed to load ImageMagick (#{...})"

lib = try_to_load "MagickWand", ->
  lname = get_flags!\match "-l(MagickWand[^%s]*)"
  local suffix
  if ffi.os == "OSX"
     suffix = ".dylib"
  elseif ffi.os == "Windows"
     suffix = ".dll"
  else
     suffix = ".so"

  lname and "lib" .. lname .. suffix

can_resize = if get_filters!
  ffi.cdef [[
    MagickBooleanType MagickResizeImage(MagickWand*,
      const size_t, const size_t,
      const FilterTypes, const double);
  ]]
  true

composite_op = {
   ["UndefinedCompositeOp"]: 0,
   ["NoCompositeOp"]: 1,
   ["ModulusAddCompositeOp"]: 2,
   ["AtopCompositeOp"]: 3,
   ["BlendCompositeOp"]: 4,
   ["BumpmapCompositeOp"]: 5,
   ["ChangeMaskCompositeOp"]: 6,
   ["ClearCompositeOp"]: 7,
   ["ColorBurnCompositeOp"]: 8,
   ["ColorDodgeCompositeOp"]: 9,
   ["ColorizeCompositeOp"]: 10,
   ["CopyBlackCompositeOp"]: 11,
   ["CopyBlueCompositeOp"]: 12,
   ["CopyCompositeOp"]: 13,
   ["CopyCyanCompositeOp"]: 14,
   ["CopyGreenCompositeOp"]: 15,
   ["CopyMagentaCompositeOp"]: 16,
   ["CopyOpacityCompositeOp"]: 17,
   ["CopyRedCompositeOp"]: 18,
   ["CopyYellowCompositeOp"]: 19,
   ["DarkenCompositeOp"]: 20,
   ["DstAtopCompositeOp"]: 21,
   ["DstCompositeOp"]: 22,
   ["DstInCompositeOp"]: 23,
   ["DstOutCompositeOp"]: 24,
   ["DstOverCompositeOp"]: 25,
   ["DifferenceCompositeOp"]: 26,
   ["DisplaceCompositeOp"]: 27,
   ["DissolveCompositeOp"]: 28,
   ["ExclusionCompositeOp"]: 29,
   ["HardLightCompositeOp"]: 30,
   ["HueCompositeOp"]: 31,
   ["InCompositeOp"]: 32,
   ["LightenCompositeOp"]: 33,
   ["LinearLightCompositeOp"]: 34,
   ["LuminizeCompositeOp"]: 35,
   ["MinusDstCompositeOp"]: 36,
   ["ModulateCompositeOp"]: 37,
   ["MultiplyCompositeOp"]: 38,
   ["OutCompositeOp"]: 39,
   ["OverCompositeOp"]: 40,
   ["OverlayCompositeOp"]: 41,
   ["PlusCompositeOp"]: 42,
   ["ReplaceCompositeOp"]: 43,
   ["SaturateCompositeOp"]: 44,
   ["ScreenCompositeOp"]: 45,
   ["SoftLightCompositeOp"]: 46,
   ["SrcAtopCompositeOp"]: 47,
   ["SrcCompositeOp"]: 48,
   ["SrcInCompositeOp"]: 49,
   ["SrcOutCompositeOp"]: 50,
   ["SrcOverCompositeOp"]: 51,
   ["ModulusSubtractCompositeOp"]: 52,
   ["ThresholdCompositeOp"]: 53,
   ["XorCompositeOp"]: 54,
   ["DivideDstCompositeOp"]: 55,
   ["DistortCompositeOp"]: 56,
   ["BlurCompositeOp"]: 57,
   ["PegtopLightCompositeOp"]: 58,
   ["VividLightCompositeOp"]: 59,
   ["PinLightCompositeOp"]: 60,
   ["LinearDodgeCompositeOp"]: 61,
   ["LinearBurnCompositeOp"]: 62,
   ["MathematicsCompositeOp"]: 63,
   ["DivideSrcCompositeOp"]: 64,
   ["MinusSrcCompositeOp"]: 65,
   ["DarkenIntensityCompositeOp"]: 66,
   ["LightenIntensityCompositeOp"]: 67
}

gravity_str = {
  "ForgetGravity",
  "NorthWestGravity",
  "NorthGravity",
  "NorthEastGravity",
  "WestGravity",
  "CenterGravity",
  "EastGravity",
  "SouthWestGravity",
  "SouthGravity",
  "SouthEastGravity",
  "StaticGravity"
}

gravity_type = {}


for i, t in ipairs gravity_str
  gravity_type[t] = i

lib.MagickWandGenesis!

filter = (name) -> lib[name .. "Filter"]

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

class Image
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
    gravity_str[lib.MagickGetImageGravity @wand]

  set_gravity: (typestr) =>
     type = gravity_type[typestr]
     error "invalid gravity type" unless type
     lib.MagickSetImageGravity @wand, type

  strip: =>
     lib.MagickStripImage @wand

  _keep_aspect: (w,h) =>
    if not w and h
      @get_width! / @get_height! * h, h
    elseif w and not h
      w, @get_height! / @get_width! * w
    else
      w,h

  clone: =>
    wand = lib.NewMagickWand!
    lib.MagickAddImage wand, @wand
    Image wand, @path

  coalesce: =>
    @wand = ffi.gc lib.MagickCoalesceImages(@wand), ffi.DestroyMagickWand
    true

  resize: (w,h, f="Lanczos2", blur=1.0) =>
    error "Failed to load filter list, can't resize" unless can_resize
    w, h = @_keep_aspect w,h
    handle_result @,
      lib.MagickResizeImage @wand, w, h, filter(f), blur

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

  composite: (blob, x, y, opstr="OverCompositeOp") =>
    if type(blob) == "table" and blob.__class == Image
      blob = blob.wand

    op = composite_op[opstr]
    error "invalid operator type" unless op
    handle_result @,
      lib.MagickCompositeImage @wand, blob, op, x, y

  -- resize but crop image to maintain aspect ratio
  resize_and_crop: (w,h) =>
    src_w, src_h = @get_width!, @get_height!

    ar_src = src_w / src_h
    ar_dest = w / h

    if ar_dest > ar_src
      new_height = w / ar_src
      @resize w, new_height
      @crop w, h, 0, (new_height - h) / 2
    else
      new_width = h * ar_src
      @resize new_width, h
      @crop w, h, (new_width - w) / 2, 0

  scale_and_crop: (w,h) =>
    src_w, src_h = @get_width!, @get_height!

    ar_src = src_w / src_h
    ar_dest = w / h

    if ar_dest > ar_src
      new_height = w / ar_src
      @resize w, new_height
      @scale w, h
    else
      new_width = h * ar_src
      @resize new_width, h
      @scale w, h

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

  __tostring: =>
    "Image<#{@path}, #{@wand}>"

load_image = (path) ->
  wand = ffi.gc lib.NewMagickWand!, lib.DestroyMagickWand
  if 0 == lib.MagickReadImage wand, path
    code, msg = get_exception wand
    return nil, msg, code

  Image wand, path

load_image_from_blob = (blob) ->
  wand = ffi.gc lib.NewMagickWand!, lib.DestroyMagickWand
  if 0 == lib.MagickReadImageBlob wand, blob, #blob
    code, msg = get_exception wand
    return nil, msg, code

  Image wand, "<from_blob>"

tonumber = tonumber
parse_size_str = (str, src_w, src_h) ->
  w, h, rest = str\match "^(%d*%%?)x(%d*%%?)(.*)$"
  return nil, "failed to parse string (#{str})" if not w

  if p = w\match "(%d+)%%"
    w = tonumber(p) / 100 * src_w
  else
    w = tonumber w

  if p = h\match "(%d+)%%"
    h = tonumber(p) / 100 * src_h
  else
    h = tonumber h

  center_crop = rest\match"#" and true

  crop_x, crop_y = rest\match "%+(%d+)%+(%d+)"
  if crop_x
    crop_x = tonumber crop_x
    crop_y = tonumber crop_y
  else
    -- by default we use the dimensions as max sizes
    if w and h and not center_crop
      unless rest\match"!"
        if src_w/src_h > w/h
          h = nil
        else
          w = nil

  {
    :w, :h
    :crop_x, :crop_y
    :center_crop
  }

thumb = (img, size_str, output) ->
  if type(img) == "string"
    img = assert load_image img

  src_w, src_h = img\get_width!, img\get_height!
  opts = parse_size_str size_str, src_w, src_h

  if opts.center_crop
    img\resize_and_crop opts.w, opts.h
  elseif opts.crop_x
    img\crop opts.w, opts.h, opts.crop_x, opts.crop_y
  else
    img\resize opts.w, opts.h

  ret = if output
    img\write output
  else
    img\get_blob!

  ret

{ :load_image, :load_image_from_blob, :thumb, :Image, :parse_size_str, :VERSION }

