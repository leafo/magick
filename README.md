# magick

[![Build Status](https://travis-ci.org/leafo/magick.svg?branch=master)](https://travis-ci.org/leafo/magick)

Lua bindings to ImageMagick's [MagicWand](http://www.imagemagick.org/script/magick-wand.php) for LuaJIT using FFI.

## Installation

You'll need both LuaJIT (any version) and MagickWand installed. On Ubuntu you might run:

```bash
$ sudo apt-get install luajit
$ sudo apt-get install libmagickwand-dev
```

It's recommended to use LuaRocks to install **magick**.

```bash
$ sudo apt-get install luarocks
$ luarocks install magick
```

## Basic Usage

If you just need to resize an image, use the `thumb` function. It can handle a
variety of resize operations and will clean up the image afterwards.

```lua
local magick = require("magick")
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

If you need more advanced image operations, you'll need to work with the
`Image` object. Read on.

## Functions

All functions contained in the table returned by `require("magick")`.

#### `thumb(input_fname, size_str, out_fname=nil)`

Loads and resizes image. Write output to `out_fname` if provided, otherwise
return image blob. (`input_fname` can optionally be an instance of `Image`)

#### `load_image(fname)`

Return a new `Image` instance, loaded from filename. Returns `nil` and error
message if image could not be loaded.

#### `load_image_from_blob(blob)`

Loads an image from a Lua string containing the binary image data.

## `Image` object

Calling `load_image` or `load_image_from_blob` returns an `Image` object.


```lua
local magick = require "magick"

local img = assert(magick.load_image("hello.png"))

print("width:", img:get_width(), "height:", img:get_height());

img:resize(200, 200)
img:write("resized.png")
```

Images are automatically freed from memory by LuaJIT's garbage collector.

### Methods

Methods mutate the current image when appropriate. Use `clone` to get an
independent copy.

#### `img:resize(w,h, f="Lanczos2", blur=1.0)`

Resizes the image, `f` is resize function, see [Filer Types](http://www.imagemagick.org/api/MagickCore/resample_8h.html#a12be80da7313b1cc5a7e1061c0c108ea)

#### `img:adaptive_resize(w,h)`

Resizes the image using [adaptive resize](http://imagemagick.org/Usage/resize/#adaptive-resize)

#### `img:crop(w,h, x=0, y=0)`

Crops image to `w`,`h` where the top left is `x`, `y`

#### `img:blur(sigma, radius=0)`

Blurs the image with specified paramaters. See [Blur Arguments](http://www.imagemagick.org/Usage/blur/#blur_args)

#### `img:rotate(degrees, r=0, g=0, b)`

Rotates the image by specified number of degrees. The image dimensions will
enlarge to prevent cropping. The triangles on the corners are filled with the
color specified by `r`, `g`, `b`. The color components are specified as
floating point numbers from 0 to 1.

#### `img:sharpen(sigma, radius=0)`

Sharpens the image with specified parameters. See [Sharpening Images](http://www.imagemagick.org/Usage/blur/#sharpen)

#### `img:resize_and_crop(w,h)`

Resizes the image to `w`,`h`. The image will be cropped if necessary to
maintain its aspect ratio.

#### `img:get_blob()`

Returns Lua string containing the binary data of the image. The blob is
formatated the same as the image's current format (eg. PNG, Gif, etc.). Use
`image:set_format` to change the format.

#### `img:write(fname)`

Writes the the image to disk

#### `img:get_width()`

Gets the width of the image

#### `img:get_height()`

Gets the height of the image

#### `img:get_format()`

Gets the current format of image as a file extension like `"png"` or `"bmp"`.
Use `image:set_format` to change the format.

#### `img:set_format(format)`

Sets the format of the image, takes a file extension like `"png"` or `"bmp"`

#### `img:get_quality()`

Gets the image compression quality.

#### `img:set_quality(quality)`

Sets the image compression quality.

#### `img:get_gravity()`

Gets the image gravity type.

#### `img:set_gravity(gravity)`

Sets the image's gravity type:

`gravity` can be one of:

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
	

#### `img:get_option(magick, key)`

Returns all the option names that match the specified pattern associated with a
image (e.g `img:get_option("webp", "lossless")`)

#### `img:set_option(magick, key, value)`

Associates one or options with the img (e.g `img:set_option("webp", "lossless", "0")`)

#### `img:scale(w, h)`

Scale the size of an image to the given dimensions.

#### `img:coalesce()`

Coalesces the current image by compositing each frame on the previous frame.
This un-optimized animated images to make them suitable for other methods.

#### `img:composite(source, x, y, compose)`

Composite another image onto another at the specified offset `x`, `y`.

`compose` can be one of:

	"NoCompositeOp"
	"ModulusAddCompositeOp"
	"AtopCompositeOp"
	"BlendCompositeOp"
	"BumpmapCompositeOp"
	"ChangeMaskCompositeOp"
	"ClearCompositeOp"
	"ColorBurnCompositeOp"
	"ColorDodgeCompositeOp"
	"ColorizeCompositeOp"
	"CopyBlackCompositeOp"
	"CopyBlueCompositeOp"
	"CopyCompositeOp"
	"CopyCyanCompositeOp"
	"CopyGreenCompositeOp"
	"CopyMagentaCompositeOp"
	"CopyOpacityCompositeOp"
	"CopyRedCompositeOp"
	"CopyYellowCompositeOp"
	"DarkenCompositeOp"
	"DstAtopCompositeOp"
	"DstCompositeOp"
	"DstInCompositeOp"
	"DstOutCompositeOp"
	"DstOverCompositeOp"
	"DifferenceCompositeOp"
	"DisplaceCompositeOp"
	"DissolveCompositeOp"
	"ExclusionCompositeOp"
	"HardLightCompositeOp"
	"HueCompositeOp"
	"InCompositeOp"
	"LightenCompositeOp"
	"LinearLightCompositeOp"
	"LuminizeCompositeOp"
	"MinusDstCompositeOp"
	"ModulateCompositeOp"
	"MultiplyCompositeOp"
	"OutCompositeOp"
	"OverCompositeOp"
	"OverlayCompositeOp"
	"PlusCompositeOp"
	"ReplaceCompositeOp"
	"SaturateCompositeOp"
	"ScreenCompositeOp"
	"SoftLightCompositeOp"
	"SrcAtopCompositeOp"
	"SrcCompositeOp"
	"SrcInCompositeOp"
	"SrcOutCompositeOp"
	"SrcOverCompositeOp"
	"ModulusSubtractCompositeOp"
	"ThresholdCompositeOp"
	"XorCompositeOp"
	"DivideDstCompositeOp"
	"DistortCompositeOp"
	"BlurCompositeOp"
	"PegtopLightCompositeOp"
	"VividLightCompositeOp"
	"PinLightCompositeOp"
	"LinearDodgeCompositeOp"
	"LinearBurnCompositeOp"
	"MathematicsCompositeOp"
	"DivideSrcCompositeOp"
	"MinusSrcCompositeOp"
	"DarkenIntensityCompositeOp"
	"LightenIntensityCompositeOp"


#### `img:strip()`

Strips image of all profiles and comments, useful for removing exif and other data

#### `r,g,b,a = img:get_pixel(x, y)`

Get the r,g,b,a color components of a pixel in the image as doubles from `0` to `1`

#### `img:clone()`

Returns a copy of the image.

#### `img:destroy()`

Immediately frees the memory associated with the image, it is invalid to use the
image after calling this method. It is unecessary to call this method normally
as images are tracked by the garbage collector.

# Tests

Tests use [Busted](http://olivinelabs.com/busted). Install and execute the
following command to run tests. You can check the output in
`spec/output_images/`.

```bash
$ busted
```

# Contact

Author: Leaf Corcoran (leafo) ([@moonscript](http://twitter.com/moonscript))  
Email: leafot@gmail.com  
Homepage: <http://leafo.net>  

