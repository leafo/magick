FROM ghcr.io/leafo/lapis-archlinux-itchio
MAINTAINER leaf corcoran <leafot@gmail.com>

RUN pacman -Sy graphicsmagick imagemagick --noconfirm

WORKDIR /magick
ADD . .
ENTRYPOINT ./arch-ci.sh

