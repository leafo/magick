local ffi = require("ffi")
local lib
lib = require("magick.gmwand.lib").lib
local data = require("magick.gmwand.data")
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
      return tonumber(lib.MagickGetImageWidth(self.wand))
    end,
    get_height = function(self)
      return tonumber(lib.MagickGetImageHeight(self.wand))
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
    get_depth = function(self)
      return tonumber(lib.MagickGetImageDepth(self.wand))
    end,
    set_depth = function(self, d)
      return handle_result(self, lib.MagickSetImageDepth(self.wand, d))
    end,
    clone = function(self)
      local wand = ffi.gc(lib.CloneMagickWand(self.wand), lib.DestroyMagickWand)
      return Image(wand, self.path)
    end,
    resize = function(self, w, h, filter, blur)
      if filter == nil then
        filter = "Lanczos"
      end
      if blur == nil then
        blur = 1.0
      end
      filter = assert(data.filters:to_int(filter .. "Filter"), "invalid filter")
      w, h = self:_keep_aspect(w, h)
      return handle_result(self, lib.MagickResizeImage(self.wand, w, h, filter, blur))
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
    modulate = function(self, brightness, saturation, hue)
      if brightness == nil then
        brightness = 100
      end
      if saturation == nil then
        saturation = 100
      end
      if hue == nil then
        hue = 100
      end
      return handle_result(self, lib.MagickModulateImage(self.wand, brightness, saturation, hue))
    end,
    write = function(self, fname)
      return handle_result(self, lib.MagickWriteImage(self.wand, fname))
    end,
    composite = function(self, blob, x, y, op)
      if op == nil then
        op = "OverCompositeOp"
      end
      if type(blob) == "table" and blob.__class == Image then
        blob = blob.wand
      end
      op = assert(data.composite_operators:to_int(op), "invalid operator type")
      return handle_result(self, lib.MagickCompositeImage(self.wand, blob, op, x, y))
    end,
    sharpen = function(self, sigma, radius)
      if radius == nil then
        radius = 0
      end
      return handle_result(self, lib.MagickSharpenImage(self.wand, radius, sigma))
    end,
    set_quality = function(self, quality)
      return handle_result(self, lib.MagickSetCompressionQuality(self.wand, quality))
    end,
    get_blob = function(self)
      local len = ffi.new("size_t[1]", 0)
      local blob = ffi.gc(lib.MagickWriteImageBlob(self.wand, len), lib.MagickRelinquishMemory)
      return ffi.string(blob, len[0])
    end,
    auto_orient = function(self)
      return handle_result(self, lib.MagickAutoOrientImage(self.wand, 0))
    end,
    reset_page = function(self)
      return lib.MagickSetImagePage(self.wand, self:get_width(), self:get_height(), 0, 0)
    end,
    __tostring = function(self)
      return "GMImage<" .. tostring(self.path) .. ", " .. tostring(self.wand) .. ">"
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
