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
    resize = function(self, w, h, filter, blur)
      if filter == nil then
        filter = "Lanczos"
      end
      if blur == nil then
        blur = 1.0
      end
      filter = assert(data.filters:to_int(filter .. "Filter"), "invalid filter")
      w, h = self:_keep_aspect(w, h)
      return lib.MagickResizeImage(self.wand, w, h, filter, blur)
    end,
    scale = function(self, w, h)
      w, h = self:_keep_aspect(w, h)
      return lib.MagickScaleImage(self.wand, w, h)
    end,
    crop = function(self, w, h, x, y)
      if x == nil then
        x = 0
      end
      if y == nil then
        y = 0
      end
      return lib.MagickCropImage(self.wand, w, h, x, y)
    end,
    write = function(self, fname)
      return lib.MagickWriteImage(self.wand, fname)
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
  self.load_from_blob = function(self, blob) end
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Image = _class_0
end
return {
  Image = Image
}
