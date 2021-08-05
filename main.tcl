#!/usr/bin/wish

source "console.tcl"
source "functions.tcl"
source "game.tcl"

loadResources

set console [Console new]

every 100 {
  global console
  $console update
}
