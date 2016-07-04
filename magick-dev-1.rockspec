package = "magick"
version = "dev-1"

source = {
  url = "git://github.com/leafo/magick.git",
}

description = {
  summary = "Lua bindings to ImageMagick & GraphicsMagick for LuaJIT using FFI",
  license = "MIT",
  maintainer = "Leaf Corcoran <leafot@gmail.com>",
}

dependencies = {
  "lua == 5.1", -- how to do luajit?
}

build = {
  type = "builtin",
  modules = {
    ["magick"] = "magick/init.lua",
    ["magick.base_image"] = "magick/base_image.lua",
    ["magick.enum"] = "magick/enum.lua",
    ["magick.gmwand"] = "magick/gmwand.lua",
    ["magick.gmwand.data"] = "magick/gmwand/data.lua",
    ["magick.gmwand.image"] = "magick/gmwand/image.lua",
    ["magick.gmwand.lib"] = "magick/gmwand/lib.lua",
    ["magick.thumb"] = "magick/thumb.lua",
    ["magick.version"] = "magick/version.lua",
    ["magick.wand"] = "magick/wand.lua",
    ["magick.wand.data"] = "magick/wand/data.lua",
    ["magick.wand.image"] = "magick/wand/image.lua",
    ["magick.wand.lib"] = "magick/wand/lib.lua",
  }
}
