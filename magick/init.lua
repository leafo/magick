local VERSION = "1.1.0"
local ffi = require("ffi")
local lib, can_resize
do
  local _obj_0 = require("magick.wand.lib")
  lib, can_resize = _obj_0.lib, _obj_0.can_resize
end
local composite_op = {
  ["UndefinedCompositeOp"] = 0,
  ["NoCompositeOp"] = 1,
  ["ModulusAddCompositeOp"] = 2,
  ["AtopCompositeOp"] = 3,
  ["BlendCompositeOp"] = 4,
  ["BumpmapCompositeOp"] = 5,
  ["ChangeMaskCompositeOp"] = 6,
  ["ClearCompositeOp"] = 7,
  ["ColorBurnCompositeOp"] = 8,
  ["ColorDodgeCompositeOp"] = 9,
  ["ColorizeCompositeOp"] = 10,
  ["CopyBlackCompositeOp"] = 11,
  ["CopyBlueCompositeOp"] = 12,
  ["CopyCompositeOp"] = 13,
  ["CopyCyanCompositeOp"] = 14,
  ["CopyGreenCompositeOp"] = 15,
  ["CopyMagentaCompositeOp"] = 16,
  ["CopyOpacityCompositeOp"] = 17,
  ["CopyRedCompositeOp"] = 18,
  ["CopyYellowCompositeOp"] = 19,
  ["DarkenCompositeOp"] = 20,
  ["DstAtopCompositeOp"] = 21,
  ["DstCompositeOp"] = 22,
  ["DstInCompositeOp"] = 23,
  ["DstOutCompositeOp"] = 24,
  ["DstOverCompositeOp"] = 25,
  ["DifferenceCompositeOp"] = 26,
  ["DisplaceCompositeOp"] = 27,
  ["DissolveCompositeOp"] = 28,
  ["ExclusionCompositeOp"] = 29,
  ["HardLightCompositeOp"] = 30,
  ["HueCompositeOp"] = 31,
  ["InCompositeOp"] = 32,
  ["LightenCompositeOp"] = 33,
  ["LinearLightCompositeOp"] = 34,
  ["LuminizeCompositeOp"] = 35,
  ["MinusDstCompositeOp"] = 36,
  ["ModulateCompositeOp"] = 37,
  ["MultiplyCompositeOp"] = 38,
  ["OutCompositeOp"] = 39,
  ["OverCompositeOp"] = 40,
  ["OverlayCompositeOp"] = 41,
  ["PlusCompositeOp"] = 42,
  ["ReplaceCompositeOp"] = 43,
  ["SaturateCompositeOp"] = 44,
  ["ScreenCompositeOp"] = 45,
  ["SoftLightCompositeOp"] = 46,
  ["SrcAtopCompositeOp"] = 47,
  ["SrcCompositeOp"] = 48,
  ["SrcInCompositeOp"] = 49,
  ["SrcOutCompositeOp"] = 50,
  ["SrcOverCompositeOp"] = 51,
  ["ModulusSubtractCompositeOp"] = 52,
  ["ThresholdCompositeOp"] = 53,
  ["XorCompositeOp"] = 54,
  ["DivideDstCompositeOp"] = 55,
  ["DistortCompositeOp"] = 56,
  ["BlurCompositeOp"] = 57,
  ["PegtopLightCompositeOp"] = 58,
  ["VividLightCompositeOp"] = 59,
  ["PinLightCompositeOp"] = 60,
  ["LinearDodgeCompositeOp"] = 61,
  ["LinearBurnCompositeOp"] = 62,
  ["MathematicsCompositeOp"] = 63,
  ["DivideSrcCompositeOp"] = 64,
  ["MinusSrcCompositeOp"] = 65,
  ["DarkenIntensityCompositeOp"] = 66,
  ["LightenIntensityCompositeOp"] = 67
}
local gravity_str = {
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
local colorspace = {
  ["UndefinedColorspace"] = 0,
  ["RGBColorspace"] = 1,
  ["GRAYColorspace"] = 2,
  ["TransparentColorspace"] = 3,
  ["OHTAColorspace"] = 4,
  ["LabColorspace"] = 5,
  ["XYZColorspace"] = 6,
  ["YCbCrColorspace"] = 7,
  ["YCCColorspace"] = 8,
  ["YIQColorspace"] = 9,
  ["YPbPrColorspace"] = 10,
  ["YUVColorspace"] = 11,
  ["CMYKColorspace"] = 12,
  ["sRGBColorspace"] = 13,
  ["HSBColorspace"] = 14,
  ["HSLColorspace"] = 15,
  ["HWBColorspace"] = 16,
  ["Rec601LumaColorspace"] = 17,
  ["Rec601YCbCrColorspace"] = 18,
  ["Rec709LumaColorspace"] = 19,
  ["Rec709YCbCrColorspace"] = 20,
  ["LogColorspace"] = 21,
  ["CMYColorspace"] = 22,
  ["LuvColorspace"] = 23,
  ["HCLColorspace"] = 24,
  ["LCHColorspace"] = 25,
  ["LMSColorspace"] = 26,
  ["LCHabColorspace"] = 27,
  ["LCHuvColorspace"] = 28,
  ["scRGBColorspace"] = 29,
  ["HSIColorspace"] = 30,
  ["HSVColorspace"] = 31,
  ["HCLpColorspace"] = 32,
  ["YDbDrColorspace"] = 33,
  ["xyYColorspace"] = 34
}
local noise_type = {
  ["UniformNoise"] = 0,
  ["GaussianNoise"] = 1,
  ["MultiplicativeGaussianNoise"] = 2,
  ["ImpulseNoise"] = 3,
  ["LaplacianNoise"] = 4,
  ["PoissonNoise"] = 5
}
local _ = {
  evaluate_operator = {
    ["UndefinedEvaluateOperator"] = 0,
    ["AddEvaluateOperator"] = 1,
    ["AndEvaluateOperator"] = 2,
    ["DivideEvaluateOperator"] = 3,
    ["LeftShiftEvaluateOperator"] = 4,
    ["MaxEvaluateOperator"] = 5,
    ["MinEvaluateOperator"] = 6,
    ["MultiplyEvaluateOperator"] = 7,
    ["OrEvaluateOperator"] = 8,
    ["RightShiftEvaluateOperator"] = 9,
    ["SetEvaluateOperator"] = 10,
    ["SubtractEvaluateOperator"] = 11,
    ["XorEvaluateOperator"] = 12,
    ["PowEvaluateOperator"] = 13,
    ["LogEvaluateOperator"] = 14,
    ["ThresholdEvaluateOperator"] = 15,
    ["ThresholdBlackEvaluateOperator"] = 16,
    ["ThresholdWhiteEvaluateOperator"] = 17,
    ["GaussianNoiseEvaluateOperator"] = 18,
    ["ImpulseNoiseEvaluateOperator"] = 19,
    ["LaplacianNoiseEvaluateOperator"] = 20,
    ["MultiplicativeNoiseEvaluateOperator"] = 21,
    ["PoissonNoiseEvaluateOperator"] = 22,
    ["UniformNoiseEvaluateOperator"] = 23,
    ["CosineEvaluateOperator"] = 24,
    ["SineEvaluateOperator"] = 25,
    ["AddModulusEvaluateOperator"] = 26,
    ["MeanEvaluateOperator"] = 27,
    ["AbsEvaluateOperator"] = 28,
    ["ExponentialEvaluateOperator"] = 29,
    ["MedianEvaluateOperator"] = 30,
    ["SumEvaluateOperator"] = 31,
    ["RootMeanSquareEvaluateOperator"] = 32
  }
}
local boolean_type = {
  ["MagickFalse"] = 0,
  ["MagickTrue"] = 1
}
local gravity_type = { }
for i, t in ipairs(gravity_str) do
  gravity_type[t] = i
end
lib.MagickWandGenesis()
local filter
filter = function(name)
  return lib[name .. "Filter"]
end
local get_exception
get_exception = function(wand)
  local etype = ffi.new("ExceptionType[1]", 0)
  local msg = ffi.string(ffi.gc(lib.MagickGetException(wand, etype), lib.MagickRelinquishMemory))
  return etype[0], msg
end
local handle_result
handle_result = function(img_or_wand, status)
  local wand = img_or_wand.wand or img_or_wand
  if status == 0 then
    local code, msg = get_exception(wand)
    return nil, msg, code
  else
    return true
  end
end
local Image
do
  local _class_0
  local _base_0 = {
    get_width = function(self)
      return lib.MagickGetImageWidth(self.wand)
    end,
    get_height = function(self)
      return lib.MagickGetImageHeight(self.wand)
    end,
    get_format = function(self)
      local format = lib.MagickGetImageFormat(self.wand)
      do
        local _with_0 = ffi.string(format):lower()
        lib.MagickRelinquishMemory(format)
        return _with_0
      end
    end,
    set_format = function(self, format)
      return handle_result(self, lib.MagickSetImageFormat(self.wand, format))
    end,
    get_quality = function(self)
      return lib.MagickGetImageCompressionQuality(self.wand)
    end,
    set_quality = function(self, quality)
      return handle_result(self, lib.MagickSetImageCompressionQuality(self.wand, quality))
    end,
    get_option = function(self, magick, key)
      local format = magick .. ":" .. key
      local option_str = lib.MagickGetOption(self.wand, format)
      do
        local _with_0 = ffi.string(option_str)
        lib.MagickRelinquishMemory(option_str)
        return _with_0
      end
    end,
    set_option = function(self, magick, key, value)
      local format = magick .. ":" .. key
      return handle_result(self, lib.MagickSetOption(self.wand, format, value))
    end,
    get_gravity = function(self)
      return gravity_str[lib.MagickGetImageGravity(self.wand)]
    end,
    set_gravity = function(self, typestr)
      local type = gravity_type[typestr]
      if not (type) then
        error("invalid gravity type")
      end
      return lib.MagickSetImageGravity(self.wand, type)
    end,
    strip = function(self)
      return lib.MagickStripImage(self.wand)
    end,
    _keep_aspect = function(self, w, h)
      if not w and h then
        return self:get_width() / self:get_height() * h, h
      elseif w and not h then
        return w, self:get_height() / self:get_width() * w
      else
        return w, h
      end
    end,
    clone = function(self)
      local wand = lib.NewMagickWand()
      lib.MagickAddImage(wand, self.wand)
      return Image(wand, self.path)
    end,
    coalesce = function(self)
      self.wand = ffi.gc(lib.MagickCoalesceImages(self.wand), ffi.DestroyMagickWand)
      return true
    end,
    resize = function(self, w, h, f, blur)
      if f == nil then
        f = "Lanczos2"
      end
      if blur == nil then
        blur = 1.0
      end
      if not (can_resize) then
        error("Failed to load filter list, can't resize")
      end
      w, h = self:_keep_aspect(w, h)
      return handle_result(self, lib.MagickResizeImage(self.wand, w, h, filter(f), blur))
    end,
    adaptive_resize = function(self, w, h)
      w, h = self:_keep_aspect(w, h)
      return handle_result(self, lib.MagickAdaptiveResizeImage(self.wand, w, h))
    end,
    scale = function(self, w, h)
      w, h = self:_keep_aspect(w, h)
      return handle_result(self, lib.MagickScaleImage(self.wand, w, h))
    end,
    crop = function(self, w, h, x, y)
      if x == nil then
        x = 0
      end
      if y == nil then
        y = 0
      end
      return handle_result(self, lib.MagickCropImage(self.wand, w, h, x, y))
    end,
    blur = function(self, sigma, radius)
      if radius == nil then
        radius = 0
      end
      return handle_result(self, lib.MagickBlurImage(self.wand, radius, sigma))
    end,
    sharpen = function(self, sigma, radius)
      if radius == nil then
        radius = 0
      end
      return handle_result(self, lib.MagickSharpenImage(self.wand, radius, sigma))
    end,
    color_space = function(self, space)
      return handle_result(self, lib.MagickTransformImageColorspace(self.wand, colorspace[space]))
    end,
    sepia = function(self, threshold)
      threshold = 65535 * threshold
      lib.MagickSetImageAlphaChannel(self.wand, 3)
      return handle_result(self, lib.MagickSepiaToneImage(self.wand, threshold))
    end,
    brightness_contrast = function(self, brightness, contrast)
      return handle_result(self, lib.MagickBrightnessContrastImage(self.wand, brightness, contrast))
    end,
    brightness_saturation_hue = function(self, brightness, saturation, hue)
      return handle_result(self, lib.MagickModulateImage(self.wand, brightness, saturation, hue))
    end,
    sketch = function(self, radius, sigma, angle)
      return handle_result(self, lib.MagickSketchImage(self.wand, radius, sigma, angle))
    end,
    flip = function(self)
      return handle_result(self, lib.MagickFlipImage(self.wand))
    end,
    flop = function(self)
      return handle_result(self, lib.MagickFlopImage(self.wand))
    end,
    oil_paint = function(self, radius)
      return handle_result(self, lib.MagickOilPaintImage(self.wand, radius))
    end,
    negate = function(self, isgray)
      return handle_result(self, lib.MagickNegateImage(self.wand, boolean_type[isgray]))
    end,
    emboss = function(self, radius, sigma)
      return handle_result(self, lib.MagickEmbossImage(self.wand, radius, sigma))
    end,
    enhance = function(self)
      return handle_result(self, lib.MagickEnhanceImage(self.wand))
    end,
    tint = function(self, color, opacity)
      local pixel_color = ffi.gc(lib.NewPixelWand(), lib.DestroyPixelWand)
      lib.PixelSetColor(pixel_color, color)
      local pixel_opacity = ffi.gc(lib.NewPixelWand(), lib.DestroyPixelWand)
      lib.PixelSetColor(pixel_opacity, opacity)
      return handle_result(self, lib.MagickTintImage(self.wand, pixel_color, pixel_opacity))
    end,
    vignette = function(self, vignette_black_point, vignette_white_point, vignette_x, vignette_y)
      local pixel = ffi.gc(lib.NewPixelWand(), lib.DestroyPixelWand)
      lib.PixelSetColor(pixel, 'transparent')
      lib.MagickSetImageBackgroundColor(self.wand, pixel)
      return handle_result(self, lib.MagickVignetteImage(self.wand, vignette_black_point, vignette_white_point, vignette_x, vignette_y))
    end,
    wave = function(self, amplitude, wave_length)
      return handle_result(self, lib.MagickWaveImage(self.wand, amplitude, wave_length))
    end,
    swirl = function(self, degrees)
      return handle_result(self, lib.MagickSwirlImage(self.wand, degrees))
    end,
    polaroid_image = function(self)
      local drawing_wand = ffi.gc(lib.NewPixelWand(), lib.DestroyPixelWand)
      return handle_result(self, lib.MagickPolaroidImage(self.wand, drawing_wand, 0.0))
    end,
    border = function(self, color, width, height)
      local pixel = ffi.gc(lib.NewPixelWand(), lib.DestroyPixelWand)
      lib.PixelSetColor(pixel, color)
      return handle_result(self, lib.MagickBorderImage(self.wand, pixel, width, height))
    end,
    charcoal = function(self, radius, sigma)
      return handle_result(self, lib.MagickCharcoalImage(self.wand, radius, sigma))
    end,
    colorize = function(self, color, opacity)
      local pixel = ffi.gc(lib.NewPixelWand(), lib.DestroyPixelWand)
      lib.PixelSetColor(pixel, color)
      local pixel_opacity = ffi.gc(lib.NewPixelWand(), lib.DestroyPixelWand)
      lib.PixelSetColor(pixel_opacity, opacity)
      return handle_result(self, lib.MagickColorizeImage(self.wand, pixel, pixel_opacity))
    end,
    threshold = function(self, width, height, offset)
      return handle_result(self, lib.MagickAdaptiveThresholdImage(self.wand, width, height, offset))
    end,
    noise = function(self, ntype)
      return handle_result(self, lib.MagickAddNoiseImage(self.wand, noise_type[ntype]))
    end,
    auto_gamma = function(self)
      return handle_result(self, lib.MagickAutoGammaImage(self.wand))
    end,
    auto_level = function(self)
      return handle_result(self, lib.MagickAutoLevelImage(self.wand))
    end,
    blue_shift = function(self, factor)
      return handle_result(self, lib.MagickBlueShiftImage(self.wand, factor))
    end,
    cycle_colormap = function(self, displace)
      return handle_result(self, lib.MagickCycleColormapImage(self.wand, displace))
    end,
    edge = function(self, radius)
      return handle_result(self, lib.MagickEdgeImage(self.wand, radius))
    end,
    evaluate = function(self, op, value)
      return handle_result(self, lib.MagickEvaluateImage(self.wand, evaluate_operator[op], value))
    end,
    rotate = function(self, degrees, r, g, b)
      if r == nil then
        r = 0
      end
      if g == nil then
        g = 0
      end
      if b == nil then
        b = 0
      end
      local pixel = ffi.gc(lib.NewPixelWand(), lib.DestroyPixelWand)
      lib.PixelSetRed(pixel, r)
      lib.PixelSetGreen(pixel, g)
      lib.PixelSetBlue(pixel, b)
      local res = {
        handle_result(self, lib.MagickRotateImage(self.wand, pixel, degrees))
      }
      return unpack(res)
    end,
    composite = function(self, blob, x, y, opstr)
      if opstr == nil then
        opstr = "OverCompositeOp"
      end
      if type(blob) == "table" and blob.__class == Image then
        blob = blob.wand
      end
      local op = composite_op[opstr]
      if not (op) then
        error("invalid operator type")
      end
      return handle_result(self, lib.MagickCompositeImage(self.wand, blob, op, x, y))
    end,
    resize_and_crop = function(self, w, h)
      local src_w, src_h = self:get_width(), self:get_height()
      local ar_src = src_w / src_h
      local ar_dest = w / h
      if ar_dest > ar_src then
        local new_height = w / ar_src
        self:resize(w, new_height)
        return self:crop(w, h, 0, (new_height - h) / 2)
      else
        local new_width = h * ar_src
        self:resize(new_width, h)
        return self:crop(w, h, (new_width - w) / 2, 0)
      end
    end,
    scale_and_crop = function(self, w, h)
      local src_w, src_h = self:get_width(), self:get_height()
      local ar_src = src_w / src_h
      local ar_dest = w / h
      if ar_dest > ar_src then
        local new_height = w / ar_src
        self:resize(w, new_height)
        return self:scale(w, h)
      else
        local new_width = h * ar_src
        self:resize(new_width, h)
        return self:scale(w, h)
      end
    end,
    get_blob = function(self)
      local len = ffi.new("size_t[1]", 0)
      local blob = ffi.gc(lib.MagickGetImageBlob(self.wand, len), lib.MagickRelinquishMemory)
      return ffi.string(blob, len[0])
    end,
    write = function(self, fname)
      return handle_result(self, lib.MagickWriteImage(self.wand, fname))
    end,
    destroy = function(self)
      if self.wand then
        lib.DestroyMagickWand(ffi.gc(self.wand, nil))
        self.wand = nil
      end
      if self.pixel_wand then
        lib.DestroyPixelWand(ffi.gc(self.pixel_wand, nil))
        self.pixel_wand = nil
      end
    end,
    get_pixel = function(self, x, y)
      self.pixel_wand = self.pixel_wand or ffi.gc(lib.NewPixelWand(), lib.DestroyPixelWand)
      assert(lib.MagickGetImagePixelColor(self.wand, x, y, self.pixel_wand), "failed to get pixel")
      return lib.PixelGetRed(self.pixel_wand), lib.PixelGetGreen(self.pixel_wand), lib.PixelGetBlue(self.pixel_wand), lib.PixelGetAlpha(self.pixel_wand)
    end,
    __tostring = function(self)
      return "Image<" .. tostring(self.path) .. ", " .. tostring(self.wand) .. ">"
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, wand, path)
      self.wand, self.path = wand, path
    end,
    __base = _base_0,
    __name = "Image"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Image = _class_0
end
local load_image
load_image = function(path)
  local wand = ffi.gc(lib.NewMagickWand(), lib.DestroyMagickWand)
  if 0 == lib.MagickReadImage(wand, path) then
    local code, msg = get_exception(wand)
    return nil, msg, code
  end
  return Image(wand, path)
end
local load_image_from_blob
load_image_from_blob = function(blob)
  local wand = ffi.gc(lib.NewMagickWand(), lib.DestroyMagickWand)
  if 0 == lib.MagickReadImageBlob(wand, blob, #blob) then
    local code, msg = get_exception(wand)
    return nil, msg, code
  end
  return Image(wand, "<from_blob>")
end
local tonumber = tonumber
local parse_size_str
parse_size_str = function(str, src_w, src_h)
  local w, h, rest = str:match("^(%d*%%?)x(%d*%%?)(.*)$")
  if not w then
    return nil, "failed to parse string (" .. tostring(str) .. ")"
  end
  do
    local p = w:match("(%d+)%%")
    if p then
      w = tonumber(p) / 100 * src_w
    else
      w = tonumber(w)
    end
  end
  do
    local p = h:match("(%d+)%%")
    if p then
      h = tonumber(p) / 100 * src_h
    else
      h = tonumber(h)
    end
  end
  local center_crop = rest:match("#") and true
  local crop_x, crop_y = rest:match("%+(%d+)%+(%d+)")
  if crop_x then
    crop_x = tonumber(crop_x)
    crop_y = tonumber(crop_y)
  else
    if w and h and not center_crop then
      if not (rest:match("!")) then
        if src_w / src_h > w / h then
          h = nil
        else
          w = nil
        end
      end
    end
  end
  return {
    w = w,
    h = h,
    crop_x = crop_x,
    crop_y = crop_y,
    center_crop = center_crop
  }
end
local save_or_get_image
save_or_get_image = function(img, output)
  local ret
  if output then
    ret = img:write(output)
  else
    ret = img:get_blob()
  end
  return ret
end
local load_image_from_path
load_image_from_path = function(img_path)
  local img = nil
  if type(img_path) == "string" then
    img = assert(load_image(img_path))
  end
  if not (img) then
    error("invalid image path")
  end
  return img
end
local get_dimensions_from_string
get_dimensions_from_string = function(size_str, src_w, src_h)
  local str_w, str_h, rest = size_str:match("^(%d*%%?)x(%d*%%?)(.*)$")
  local w = nil
  local h = nil
  do
    local p = str_w:match("(%d+)%%")
    if p then
      w = tonumber(p) / 100 * src_w
    else
      w = tonumber(str_w) or 0
    end
  end
  do
    local p = str_h:match("(%d+)%%")
    if p then
      h = tonumber(p) / 100 * src_h
    else
      h = tonumber(str_h) or 0
    end
  end
  return {
    w = w,
    h = h
  }
end
local thumb
thumb = function(img, size_str, output)
  img = load_image_from_path(img)
  local src_w, src_h = img:get_width(), img:get_height()
  local dimensions = get_dimensions_from_string(size_str, src_w, src_h)
  if dimensions.w > src_w or dimensions.h > src_h then
    if output then
      return img:write(output)
    end
    return img:get_blob()
  end
  local opts = parse_size_str(size_str, src_w, src_h)
  if opts.center_crop then
    img:resize_and_crop(opts.w, opts.h)
  elseif opts.crop_x then
    img:crop(opts.w, opts.h, opts.crop_x, opts.crop_y)
  else
    img:resize(opts.w, opts.h)
  end
  return save_or_get_image(img, output)
end
local copy_image
copy_image = function(img, output)
  img = load_image_from_path(img)
  return save_or_get_image(img, output)
end
local color_space
color_space = function(img, space, output)
  img = load_image_from_path(img)
  img:color_space(space)
  return save_or_get_image(img, output)
end
local sepia
sepia = function(img, threshold, output)
  img = load_image_from_path(img)
  img:sepia(threshold)
  return save_or_get_image(img, output)
end
local brightness_contrast
brightness_contrast = function(img, brightness, contrast, output)
  img = load_image_from_path(img)
  img:brightness_contrast(brightness, contrast)
  return save_or_get_image(img, output)
end
local sharpen
sharpen = function(img, sigma, radius, output)
  img = load_image_from_path(img)
  img:sharpen(sigma, radius)
  return save_or_get_image(img, output)
end
local blur
blur = function(img, sigma, radius, output)
  img = load_image_from_path(img)
  img:blur(sigma, radius)
  return save_or_get_image(img, output)
end
local rotate
rotate = function(img, degrees, output)
  img = load_image_from_path(img)
  img:rotate(degrees)
  return save_or_get_image(img, output)
end
local sketch
sketch = function(img, sigma, radius, angle, output)
  img = load_image_from_path(img)
  img:sketch(sigma, radius, angle)
  return save_or_get_image(img, output)
end
local vignette
vignette = function(img, vignette_black_point, vignette_white_point, vignette_x, vignette_y, output)
  img = load_image_from_path(img)
  img:vignette(vignette_black_point, vignette_white_point, vignette_x, vignette_y)
  return save_or_get_image(img, output)
end
local flip
flip = function(img, output)
  img = load_image_from_path(img)
  img:flip()
  return save_or_get_image(img, output)
end
local flop
flop = function(img, output)
  img = load_image_from_path(img)
  img:flop()
  return save_or_get_image(img, output)
end
local oil_paint
oil_paint = function(img, radius, output)
  img = load_image_from_path(img)
  img:oil_paint(radius)
  return save_or_get_image(img, output)
end
local brightness_saturation_hue
brightness_saturation_hue = function(img, brightness, saturation, hue, output)
  img = load_image_from_path(img)
  img:brightness_saturation_hue(brightness, saturation, hue)
  return save_or_get_image(img, output)
end
local negate
negate = function(img, isgray, output)
  img = load_image_from_path(img)
  img:negate(isgray)
  return save_or_get_image(img, output)
end
local emboss
emboss = function(img, radius, sigma, output)
  img = load_image_from_path(img)
  img:emboss(radius, sigma)
  return save_or_get_image(img, output)
end
local tint
tint = function(img, color, opacity, output)
  img = load_image_from_path(img)
  img:tint(color, opacity)
  return save_or_get_image(img, output)
end
local wave
wave = function(img, amplitude, wave_length, output)
  img = load_image_from_path(img)
  img:wave(amplitude, wave_length)
  return save_or_get_image(img, output)
end
local enhance
enhance = function(img, output)
  img = load_image_from_path(img)
  img:enhance()
  return save_or_get_image(img, output)
end
local swirl
swirl = function(img, degrees, output)
  img = load_image_from_path(img)
  img:swirl(degrees)
  return save_or_get_image(img, output)
end
local polaroid_image
polaroid_image = function(img, output)
  img = load_image_from_path(img)
  img:polaroid_image()
  return save_or_get_image(img, output)
end
local border
border = function(img, color, width, height, output)
  img = load_image_from_path(img)
  img:border(color, width, height)
  return save_or_get_image(img, output)
end
local charcoal
charcoal = function(img, radius, sigma, output)
  img = load_image_from_path(img)
  img:charcoal(radius, sigma)
  return save_or_get_image(img, output)
end
local colorize
colorize = function(img, color, opacity, output)
  img = load_image_from_path(img)
  img:colorize(color, opacity)
  return save_or_get_image(img, output)
end
local threshold
threshold = function(img, width, height, offset, output)
  img = load_image_from_path(img)
  img:threshold(width, height, offset)
  return save_or_get_image(img, output)
end
local auto_gamma
auto_gamma = function(img, output)
  img = load_image_from_path(img)
  img:auto_gamma()
  return save_or_get_image(img, output)
end
local auto_level
auto_level = function(img, output)
  img = load_image_from_path(img)
  img:auto_level()
  return save_or_get_image(img, output)
end
local blue_shift
blue_shift = function(img, factor, output)
  img = load_image_from_path(img)
  img:blue_shift(factor)
  return save_or_get_image(img, output)
end
local edge
edge = function(img, radius, output)
  img = load_image_from_path(img)
  img:edge(radius)
  return save_or_get_image(img, output)
end
local cycle_colormap
cycle_colormap = function(img, displace, output)
  img = load_image_from_path(img)
  img:cycle_colormap(displace)
  return save_or_get_image(img, output)
end
local evaluate
evaluate = function(img, op, value, output)
  img = load_image_from_path(img)
  img:evaluate(op, value)
  return save_or_get_image(img, output)
end
return {
  load_image = load_image,
  load_image_from_blob = load_image_from_blob,
  copy_image = copy_image,
  thumb = thumb,
  color_space = color_space,
  sepia = sepia,
  brightness_contrast = brightness_contrast,
  sharpen = sharpen,
  blur = blur,
  rotate = rotate,
  sketch = sketch,
  vignette = vignette,
  flip = flip,
  flop = flop,
  oil_paint = oil_paint,
  brightness_saturation_hue = brightness_saturation_hue,
  negate = negate,
  emboss = emboss,
  tint = tint,
  wave = wave,
  enhance = enhance,
  swirl = swirl,
  polaroid_image = polaroid_image,
  border = border,
  charcoal = charcoal,
  colorize = colorize,
  threshold = threshold,
  auto_gamma = auto_gamma,
  auto_level = auto_level,
  blue_shift = blue_shift,
  edge = edge,
  cycle_colormap = cycle_colormap,
  evaluate = evaluate,
  Image = Image,
  parse_size_str = parse_size_str,
  VERSION = VERSION
}
