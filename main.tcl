#!/usr/bin/wish

source "tamagotchi.tcl"
source "console.tcl"
source "functions.tcl"

set console [Console new]

every 100 {
  global console
  $console update
}
