FROM ghcr.io/leafo/lapis-archlinux-itchio
MAINTAINER leaf corcoran <leafot@gmail.com>

WORKDIR /magick
ADD . .
ENTRYPOINT ./arch-ci.sh

