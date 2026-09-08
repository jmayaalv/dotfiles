#!/usr/bin/env sh

# Catppuccin Macchiato
# https://github.com/catppuccin/catppuccin
# The palette the ported config was already written against: the literal
# 0xffed8796 / 0xff494d64 / 0xffb8c0e0 values in items/ are red, surface1
# and subtext1 below.

export ROSEWATER=0xfff4dbd6
export FLAMINGO=0xfff0c6c6
export PINK=0xfff5bde6
export MAUVE=0xffc6a0f6
export RED=0xffed8796
export MAROON=0xffee99a0
export PEACH=0xfff5a97f
export YELLOW=0xffeed49f
export GREEN=0xffa6da95
export TEAL=0xff8bd5ca
export SKY=0xff91d7e3
export SAPPHIRE=0xff7dc4e4
export BLUE=0xff8aadf4
export LAVENDER=0xffb7bdf8

export TEXT=0xffcad3f5
export SUBTEXT1=0xffb8c0e0
export SUBTEXT0=0xffa5adcb
export OVERLAY2=0xff939ab7
export OVERLAY1=0xff8087a2
export OVERLAY0=0xff6e738d
export SURFACE2=0xff5b6078
export SURFACE1=0xff494d64
export SURFACE0=0xff363a4f
export BASE=0xff24273a
export MANTLE=0xff1e2030
export CRUST=0xff181926

# Generic aliases used across the items
export WHITE=$TEXT
export BLACK=$CRUST
export TRANSPARENT=0x00000000

# Semantic roles
export BAR_COLOR=0xd91e2030            # mantle, ~85% opaque so blur_radius reads
export BAR_BORDER_COLOR=$SURFACE0
export ICON_COLOR=$TEXT                # default icon color
export LABEL_COLOR=$TEXT               # default label color
export BACKGROUND_1=$SURFACE0
export BACKGROUND_2=$SURFACE1

export POPUP_BACKGROUND_COLOR=$MANTLE
export POPUP_BORDER_COLOR=$SURFACE1

export SHADOW_COLOR=$CRUST
