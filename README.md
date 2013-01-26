# magick

Lua bindings to ImageMagick for LuaJIT using FFI

## Usage

```lua
local magick = require "magick"

local img = assert(magick.load_image("hello.png"))

print("width:", img:get_width(), "height:", img:get_height());

img:resize(200, 200)
img:write("resized.png")
img:destroy()
```

