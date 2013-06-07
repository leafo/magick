# magick

Lua bindings to ImageMagick for LuaJIT using FFI

## Functions

All functions contained in the table returned by `require "magick"`.

#### `thumb(input_fname, size_str, out_fname=nil)`

Loads and resizes image. Write output to `out_fname` if provided, otherwise
return image blob. (`input_fname` can optionally be an instance of `Image`,
will get automatically destroyed)

#### `load_image(fname)`

Return a new `Image` instance, loaded from filename. Returns `nil` and error
message if image could not be loaded.

#### `load_image_from_blob(blob)`

Loads an image from a Lua string containing the binary image data.

## Basic Usage

If you just need to resize an image, use the `thumb` function. It can handle a
variety of resize operations and will clean up the image afterwards.

```lua
local magick = require "magick"
magick.thumb("input.png", "100x100", "output.png")
```

The second argument to `thumb` is a size string, it can have the following
kinds of values:


```lua
"500x300"       -- Resize image such that the aspect ratio is kept,
                --  the width does not exceed 500 and the height does
                --  not exceed 300
"500x300!"      -- Resize image to 500 by 300, ignoring aspect ratio
"500x"          -- Resize width to 500 keep aspect ratio
"x300"          -- Resize height to 300 keep aspect ratio
"50%x20%"       -- Resize width to 50% and height to 20% of original
"500x300#"      -- Resize image to 500 by 300, but crop either top
                --  or bottom to keep aspect ratio
"500x300+10+20" -- Crop image to 500 by 300 at position 10,20
```

## `Image` object

Calling `load_image` or `load_image_from_blob` returns an `Image` object. Make
sure to call `destroy` to delete the image in long running programs or there
will be a memory leak.


```lua
local magick = require "magick"

local img = assert(magick.load_image("hello.png"))

print("width:", img:get_width(), "height:", img:get_height());

img:resize(200, 200)
img:write("resized.png")
img:destroy()
```

### Methods

Methods mutate the current image when appropriate. Use `clone` to get an
independent copy.

#### `img:resize(w,h, f="Lanczos2", blur=1.0)`

resize the image, `f` is resize function, see [Filer Types](http://www.imagemagick.org/api/MagickCore/resample_8h.html#a12be80da7313b1cc5a7e1061c0c108ea)

#### `img:adaptive_resize(w,h)`

resize the image using [adaptive
resize](http://imagemagick.org/Usage/resize/#adaptive-resize)

#### `img:crop(w,h, x=0, y=0)`

crop image to `w`,`h` where the top left is `x`, `y`

#### `img:blur(sigma, radius=0)`

blur image

#### `img:sharpen(sigma, radius=0)`

sharpen image

#### `img:resize_and_crop(w,h)`

resize the image to `w`,`h`, but crop if necessary to maintain aspect ratio

#### `img:get_blob()`

returns Lua string containing the binary data of the image

#### `img:write(fname)`

writes the contents of the image

#### `img:get_width()`

get width of image

#### `img:get_height()`

get height of image

#### `img:get_format()`

get the current format of image

#### `img:set_format(format)`

set the format of the image, takes a file extension like `"png"` or `"bmp"`

#### `img:get_quality()`

get the image compression quality.

#### `img:set_quality(quality)`

set the image compression quality.

#### `img:clone()`

returns a copy of the image

#### `img:destroy()`

free the memory associated with image, it is invalid to use the image after
calling this method


# Contact

Author: Leaf Corcoran (leafo) ([@moonscript](http://twitter.com/moonscript))  
Email: leafot@gmail.com  
Homepage: <http://leafo.net>  

