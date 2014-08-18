
test::
	busted

local: build
	luarocks make --local magick-dev-1.rockspec


build::
	moonc magick
