
.PHONY: test local build valgrind

test:
	busted

local: build
	luarocks --lua-version=5.1 make --local magick-dev-1.rockspec

build:
	moonc magick

valgrind:
	valgrind --leak-check=yes --trace-children=yes busted

lint::
	moonc lint_config.moon
	git ls-files | grep '\.moon$$' | xargs -n 100 moonc -l
