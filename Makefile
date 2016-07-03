
.PHONY: test local build valgrind

test:
	busted

local: build
	luarocks make --local magick-dev-1.rockspec

build:
	moonc magick

valgrind:
	valgrind --leak-check=yes --trace-children=yes busted
