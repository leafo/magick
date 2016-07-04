local ffi = require("ffi")
local lib, can_resize, get_filter
do
  local _obj_0 = require("magick.wand.lib")
  lib, can_resize, get_filter = _obj_0.lib, _obj_0.can_resize, _obj_0.get_filter
end
local composite_operators, gravity, orientation, interlace
do
  local _obj_0 = require("magick.wand.data")
  composite_operators, gravity, orientation, interlace = _obj_0.composite_operators, _obj_0.gravity, _obj_0.orientation, _obj_0.interlace
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
  local _parent_0 = require("magick.base_image")
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
      return gravity:to_str(lib.MagickGetImageGravity(self.wand))
    end,
    set_gravity = function(self, gtype)
      gtype = assert(gravity:to_int(gtype), "invalid gravity type")
      return lib.MagickSetImageGravity(self.wand, gtype)
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
      return handle_result(self, lib.MagickResizeImage(self.wand, w, h, get_filter(f), blur))
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
    composite = function(self, blob, x, y, op)
      if op == nil then
        op = "OverCompositeOp"
      end
      if type(blob) == "table" and blob.__class == Image then
        blob = blob.wand
      end
      op = assert(composite_operators:to_int(op), "invalid operator type")
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
    transpose = function(self)
      return handle_result(self, lib.MagickTransposeImage(self.wand))
    end,
    transverse = function(self)
      return handle_result(self, lib.MagickTransverseImage(self.wand))
    end,
    flip = function(self)
      return handle_result(self, lib.MagickFlipImage(self.wand))
    end,
    flop = function(self)
      return handle_result(self, lib.MagickFlopImage(self.wand))
    end,
    get_property = function(self, property)
      local res = lib.MagickGetImageProperty(self.wand, property)
      if nil ~= res then
        do
          local _with_0 = ffi.string(res)
          lib.MagickRelinquishMemory(res)
          return _with_0
        end
      else
        local code, msg = get_exception(self.wand)
        return nil, msg, code
      end
    end,
    set_property = function(self, property, value)
      return handle_result(self, lib.MagickSetImageProperty(self.wand, property, value))
    end,
    get_orientation = function(self)
      return orientation:to_str(lib.MagickGetImageOrientation(self.wand))
    end,
    set_orientation = function(self, otype)
      otype = assert(orientation:to_int(otype), "invalid orientation type")
      return lib.MagickSetImageOrientation(self.wand, otype)
    end,
    get_interlace_scheme = function(self)
      return interlace:to_str(lib.MagickGetImageInterlaceScheme(self.wand))
    end,
    set_interlace_scheme = function(self, itype)
      itype = assert(interlace:to_int(itype), "invalid interlace type")
      return lib.MagickSetImageInterlaceScheme(self.wand, itype)
    end,
    auto_orient = function(self)
      return handle_result(self, lib.MagickAutoOrientImage(self.wand))
    end,
    __tostring = function(self)
      return "Image<" .. tostring(self.path) .. ", " .. tostring(self.wand) .. ">"
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, wand, path)
      self.wand, self.path = wand, path
    end,
    __base = _base_0,
    __name = "Image",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  local self = _class_0
  self.load = function(self, path)
    local wand = ffi.gc(lib.NewMagickWand(), lib.DestroyMagickWand)
    if 0 == lib.MagickReadImage(wand, path) then
      local code, msg = get_exception(wand)
      return nil, msg, code
    end
    return self(wand, path)
  end
  self.load_from_blob = function(self, blob)
    local wand = ffi.gc(lib.NewMagickWand(), lib.DestroyMagickWand)
    if 0 == lib.MagickReadImageBlob(wand, blob, #blob) then
      local code, msg = get_exception(wand)
      return nil, msg, code
    end
    return self(wand, "<from_blob>")
  end
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Image = _class_0
end
return {
  Image = Image
}
