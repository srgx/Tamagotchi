#!/usr/bin/wish

source "console.tcl"
source "functions.tcl"

loadResources

set console [Console new]

every 200 {
  global console
  $console update
}
