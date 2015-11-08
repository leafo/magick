package = "magick"
version = "dev-1"

source = {
  url = "git://github.com/leafo/magick.git",
}

description = {
  summary = "Lua bindings to ImageMagick for LuaJIT using FFI",
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
    ["magick.gmwand.lib"] = "magick/gmwand/lib.lua",
    ["magick.wand.data"] = "magick/wand/data.lua",
    ["magick.wand.lib"] = "magick/wand/lib.lua",
  }
}
