
VERSION = "1.1.0"

ffi = require "ffi"
import lib, can_resize from require "magick.wand.lib"

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

colorspace = {
  ["UndefinedColorspace"]: 0,
  ["RGBColorspace"]: 1,
  ["GRAYColorspace"]: 2,
  ["TransparentColorspace"]: 3,
  ["OHTAColorspace"]: 4,
  ["LabColorspace"]: 5,
  ["XYZColorspace"]: 6,
  ["YCbCrColorspace"]: 7,
  ["YCCColorspace"]: 8,
  ["YIQColorspace"]: 9,
  ["YPbPrColorspace"]: 10,
  ["YUVColorspace"]: 11,
  ["CMYKColorspace"]: 12,
  ["sRGBColorspace"]: 13,
  ["HSBColorspace"]: 14,
  ["HSLColorspace"]: 15,
  ["HWBColorspace"]: 16,
  ["Rec601LumaColorspace"]: 17,
  ["Rec601YCbCrColorspace"]: 18,
  ["Rec709LumaColorspace"]:19,
  ["Rec709YCbCrColorspace"]:20,
  ["LogColorspace"]: 21,
  ["CMYColorspace"]: 22,
  ["LuvColorspace"]: 23,
  ["HCLColorspace"]: 24,
  ["LCHColorspace"]: 25,
  ["LMSColorspace"]: 26,
  ["LCHabColorspace"]: 27,
  ["LCHuvColorspace"]: 28,
  ["scRGBColorspace"]: 29,
  ["HSIColorspace"]: 30,
  ["HSVColorspace"]: 31,
  ["HCLpColorspace"]:32,
  ["YDbDrColorspace"]: 33,
  ["xyYColorspace"]: 34
}

noise_type = {
  ["UniformNoise"]: 0,
  ["GaussianNoise"]: 1,
  ["MultiplicativeGaussianNoise"]: 2,
  ["ImpulseNoise"]: 3,
  ["LaplacianNoise"]: 4,
  ["PoissonNoise"]: 5
}

evaluate_operator: {
  ["UndefinedEvaluateOperator"]: 0,
  ["AddEvaluateOperator"]: 1,
  ["AndEvaluateOperator"]: 2,
  ["DivideEvaluateOperator"]: 3,
  ["LeftShiftEvaluateOperator"]: 4,
  ["MaxEvaluateOperator"]:	5,
  ["MinEvaluateOperator"]:	6,
  ["MultiplyEvaluateOperator"]: 7,
  ["OrEvaluateOperator"]: 8,
  ["RightShiftEvaluateOperator"]: 9,
  ["SetEvaluateOperator"]: 10,
  ["SubtractEvaluateOperator"]: 11,
  ["XorEvaluateOperator"]: 12,
  ["PowEvaluateOperator"]: 13,
  ["LogEvaluateOperator"]: 14,
  ["ThresholdEvaluateOperator"]: 15,
  ["ThresholdBlackEvaluateOperator"]: 16,
  ["ThresholdWhiteEvaluateOperator"]: 17,
  ["GaussianNoiseEvaluateOperator"]: 18,
  ["ImpulseNoiseEvaluateOperator"]: 19,
  ["LaplacianNoiseEvaluateOperator"]: 20,
  ["MultiplicativeNoiseEvaluateOperator"]: 21,
  ["PoissonNoiseEvaluateOperator"]: 22,
  ["UniformNoiseEvaluateOperator"]: 23,
  ["CosineEvaluateOperator"]: 24,
  ["SineEvaluateOperator"]: 25,
  ["AddModulusEvaluateOperator"]: 26,
  ["MeanEvaluateOperator"]: 27,
  ["AbsEvaluateOperator"]: 28,
  ["ExponentialEvaluateOperator"]: 29,
  ["MedianEvaluateOperator"]: 30,
  ["SumEvaluateOperator"]: 31,
  ["RootMeanSquareEvaluateOperator"]: 32
}

boolean_type = {
  ["MagickFalse"]: 0,
  ["MagickTrue"]: 1
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
--
  color_space: (space) =>
    handle_result @,
      lib.MagickTransformImageColorspace @wand, colorspace[space]

  sepia: (threshold) =>
    threshold = 65535 * threshold
    lib.MagickSetImageAlphaChannel @wand, 3
    handle_result @,
      lib.MagickSepiaToneImage @wand, threshold

  brightness_contrast: (brightness, contrast) =>
    handle_result @,
      lib.MagickBrightnessContrastImage @wand, brightness, contrast

  brightness_saturation_hue: (brightness, saturation, hue) =>
    handle_result @,
      lib.MagickModulateImage @wand, brightness, saturation, hue

  sketch: (radius, sigma, angle) =>
    handle_result @,
      lib.MagickSketchImage @wand, radius, sigma, angle

  flip: =>
    handle_result @,
      lib.MagickFlipImage @wand

  flop: =>
    handle_result @,
      lib.MagickFlopImage @wand

  oil_paint: (radius) =>
    handle_result @,
      lib.MagickOilPaintImage @wand, radius

  negate: (isgray) =>
    handle_result @,
      lib.MagickNegateImage @wand, boolean_type[isgray]

  emboss: (radius, sigma) =>
    handle_result @,
      lib.MagickEmbossImage @wand, radius, sigma

  enhance: =>
    handle_result @,
      lib.MagickEnhanceImage @wand

  tint:(color, opacity) =>
    pixel_color = ffi.gc lib.NewPixelWand!, lib.DestroyPixelWand
    lib.PixelSetColor pixel_color, color
    pixel_opacity = ffi.gc lib.NewPixelWand!, lib.DestroyPixelWand
    lib.PixelSetColor pixel_opacity, opacity
    handle_result @,
      lib.MagickTintImage @wand, pixel_color, pixel_opacity

  vignette: (vignette_black_point, vignette_white_point, vignette_x, vignette_y) =>
    pixel = ffi.gc lib.NewPixelWand!, lib.DestroyPixelWand
    lib.PixelSetColor pixel, 'transparent'
    lib.MagickSetImageBackgroundColor self.wand, pixel
    handle_result @,
      lib.MagickVignetteImage @wand, vignette_black_point, vignette_white_point, vignette_x, vignette_y

  wave: (amplitude, wave_length) =>
    handle_result @,
      lib.MagickWaveImage @wand, amplitude, wave_length

  swirl: (degrees) =>
    handle_result @,
      lib.MagickSwirlImage @wand, degrees

  polaroid_image: =>
    drawing_wand = ffi.gc lib.NewPixelWand!, lib.DestroyPixelWand
    handle_result @,
      lib.MagickPolaroidImage @wand, drawing_wand, 0.0

  border: (color, width, height) =>
    pixel = ffi.gc lib.NewPixelWand!, lib.DestroyPixelWand
    lib.PixelSetColor pixel, color
    handle_result @,
      lib.MagickBorderImage @wand, pixel, width, height

  charcoal: (radius, sigma) =>
    handle_result @,
      lib.MagickCharcoalImage @wand, radius, sigma

  colorize: (color, opacity) =>
    pixel = ffi.gc lib.NewPixelWand!, lib.DestroyPixelWand
    lib.PixelSetColor pixel, color
    pixel_opacity = ffi.gc lib.NewPixelWand!, lib.DestroyPixelWand
    lib.PixelSetColor pixel_opacity, opacity
    handle_result@,
      lib.MagickColorizeImage @wand, pixel, pixel_opacity

  threshold: (width, height, offset) =>
    handle_result @,
      lib.MagickAdaptiveThresholdImage @wand, width, height, offset

  noise: (ntype) =>
    handle_result @,
      lib.MagickAddNoiseImage @wand, noise_type[ntype]

  auto_gamma: =>
    handle_result @,
      lib.MagickAutoGammaImage @wand

  auto_level: =>
    handle_result @,
      lib.MagickAutoLevelImage @wand

  blue_shift: (factor) =>
    handle_result @,
      lib.MagickBlueShiftImage @wand, factor

  cycle_colormap: (displace) =>
    handle_result @,
      lib.MagickCycleColormapImage @wand, displace

  edge: (radius) =>
    handle_result @,
      lib.MagickEdgeImage @wand, radius

  evaluate: (op, value) =>
    handle_result @,
      lib.MagickEvaluateImage @wand, evaluate_operator[op], value
--
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

save_or_get_image = (img, output) ->
  ret = if output
    img\write output
  else
    img\get_blob!

  ret

load_image_from_path = (img_path) ->
  img = nil
  if type(img_path) == "string"
    img = assert load_image img_path
  error "invalid image path" unless img

  img

get_dimensions_from_string = (size_str, src_w, src_h) ->
  str_w, str_h, rest = size_str\match "^(%d*%%?)x(%d*%%?)(.*)$"
  w = nil
  h = nil

  if p = str_w\match "(%d+)%%"
    w = tonumber(p) / 100 * src_w
  else
    w = tonumber(str_w) or 0

  if p = str_h\match "(%d+)%%"
    h = tonumber(p) / 100 * src_h
  else
    h = tonumber(str_h) or 0

  {:w, :h}

thumb = (img, size_str, output, allow_oversize=false, oversize_limit=5000) ->
  img = load_image_from_path(img)
  src_w, src_h = img\get_width!, img\get_height!
  dimensions = get_dimensions_from_string size_str, src_w, src_h
  if (allow_oversize and (dimensions.w > oversize_limit or dimensions.h > oversize_limit)) or (not allow_oversize and (dimensions.w > src_w or dimensions.h > src_h))
    if output
      return img\write output
    return img\get_blob!

  opts = parse_size_str size_str, src_w, src_h
  if opts.center_crop
    img\resize_and_crop opts.w, opts.h
  elseif opts.crop_x
    img\crop opts.w, opts.h, opts.crop_x, opts.crop_y
  else
    img\resize opts.w, opts.h

  return save_or_get_image img, output

copy_image = (img, output) ->
  img = load_image_from_path(img)

  return save_or_get_image img, output

color_space = (img, space, output) ->
  img = load_image_from_path(img)
  img\color_space space

  return save_or_get_image img, output

sepia = (img, threshold, output) ->
  img = load_image_from_path(img)
  img\sepia threshold

  return save_or_get_image img, output

brightness_contrast = (img, brightness, contrast, output) ->
  img = load_image_from_path(img)
  img\brightness_contrast brightness, contrast

  return save_or_get_image img, output

sharpen = (img, sigma, radius, output) ->
  img = load_image_from_path(img)
  img\sharpen sigma, radius

  return save_or_get_image img, output

blur = (img, sigma, radius, output) ->
  img = load_image_from_path(img)
  img\blur sigma, radius

  return save_or_get_image img, output

rotate = (img, degrees, output) ->
  img = load_image_from_path(img)
  img\rotate degrees

  return save_or_get_image img, output

sketch = (img, sigma, radius, angle, output) ->
  img = load_image_from_path(img)
  img\sketch sigma, radius, angle

  return save_or_get_image img, output

vignette = (img, vignette_black_point, vignette_white_point, vignette_x, vignette_y, output) ->
  img = load_image_from_path(img)
  img\vignette vignette_black_point, vignette_white_point, vignette_x, vignette_y

  return save_or_get_image img, output

flip = (img, output) ->
  img = load_image_from_path(img)
  img\flip!

  return save_or_get_image img, output

flop = (img, output) ->
  img = load_image_from_path(img)
  img\flop!

  return save_or_get_image img, output

oil_paint = (img, radius, output) ->
  img = load_image_from_path(img)
  img\oil_paint radius

  return save_or_get_image img, output

brightness_saturation_hue = (img, brightness, saturation, hue, output) ->
  img = load_image_from_path(img)
  img\brightness_saturation_hue brightness, saturation, hue

  return save_or_get_image img, output

negate = (img, isgray, output) ->
  img = load_image_from_path(img)
  img\negate isgray

  return save_or_get_image img, output

emboss = (img, radius, sigma, output) ->
  img = load_image_from_path(img)
  img\emboss radius, sigma

  return save_or_get_image img, output

tint = (img, color, opacity, output) ->
  img = load_image_from_path(img)
  img\tint color, opacity

  return save_or_get_image img, output

wave = (img, amplitude, wave_length, output) ->
  img = load_image_from_path(img)
  img\wave amplitude, wave_length

  return save_or_get_image img, output

enhance = (img, output) ->
  img = load_image_from_path(img)
  img\enhance!

  return save_or_get_image img, output

swirl = (img, degrees, output) ->
  img = load_image_from_path(img)
  img\swirl degrees

  return save_or_get_image img, output

polaroid_image = (img, output) ->
  img = load_image_from_path(img)
  img\polaroid_image!

  return save_or_get_image img, output

border = (img, color, width, height, output) ->
  img = load_image_from_path(img)
  img\border color, width, height

  return save_or_get_image img, output

charcoal = (img, radius, sigma, output) ->
  img = load_image_from_path(img)
  img\charcoal radius, sigma

  return save_or_get_image img, output

colorize = (img, color, opacity, output) ->
  img = load_image_from_path(img)
  img\colorize color, opacity

  return save_or_get_image img, output

threshold = (img, width, height, offset, output) ->
  img = load_image_from_path(img)
  img\threshold width, height, offset

  return save_or_get_image img, output

auto_gamma = (img, output) ->
  img = load_image_from_path(img)
  img\auto_gamma!

  return save_or_get_image img, output

auto_level = (img, output) ->
  img = load_image_from_path(img)
  img\auto_level!

  return save_or_get_image img, output

blue_shift = (img, factor, output) ->
  img = load_image_from_path(img)
  img\blue_shift factor

  return save_or_get_image img, output

edge = (img, radius, output) ->
  img = load_image_from_path(img)
  img\edge radius

  return save_or_get_image img, output

cycle_colormap = (img, displace, output) ->
  img = load_image_from_path(img)
  img\cycle_colormap displace

  return save_or_get_image img, output

evaluate = (img, op, value, output) ->
  img = load_image_from_path(img)
  img\evaluate op, value

  return save_or_get_image img, output

{
  :load_image,
  :load_image_from_blob,
  :copy_image,
  :thumb,
  :color_space,
  :sepia,
  :brightness_contrast,
  :sharpen,
  :blur,
  :rotate,
  :sketch,
  :vignette,
  :flip,
  :flop,
  :oil_paint,
  :brightness_saturation_hue,
  :negate,
  :emboss,
  :tint,
  :wave,
  :enhance,
  :swirl,
  :polaroid_image,
  :border,
  :charcoal,
  :colorize,
  :threshold,
  :auto_gamma,
  :auto_level,
  :blue_shift,
  :edge,
  :cycle_colormap,
  :evaluate,
  :Image,
  :parse_size_str,
  :VERSION
}
