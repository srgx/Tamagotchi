
proc every {ms body} {
  eval $body; after $ms [namespace code [info level 0]]
}

proc loadResources {} {

  global foodMenuScreens lightMenuScreens medicineScreens skullImage\
         waveImage dirtImage digits eggScreens babyScreens\
         mealEatingScreens snackEatingScreens meterImages heartInside gameWait\
         gameLeft gameRight gameArrowLeft gameArrowRight winScreens loseScreens\
         gameVs

  set skullImage [loadImage assets/skull]
  set waveImage [loadImage assets/wave]
  set dirtImage [loadImage assets/dirt]
  set heartInside [loadImage assets/heart_inside]

  set arrowImage [loadImage assets/arrow]
  set txt [loadImage assets/light_text]
  lappend lightMenuScreens [concat $txt $arrowImage]\
                           [concat $txt [movePositionsVertical 8 $arrowImage]]
  set txt [loadImage assets/food_text]
  lappend foodMenuScreens [concat $txt $arrowImage]\
                          [concat $txt [movePositionsVertical 8 $arrowImage]]

  for {set i 0} {$i < 10} {incr i} {
    lappend digits [loadImage assets/digits/$i]
  }

  set temp [loadImage assets/medicine]
  lappend medicineScreens $temp
  set vals {{{8 13} {8 14}} {{8 15} {8 16} {8 17}}  {{8 18} {8 19}}}
  for {set i 0} {$i < 3} {incr i} {
    set temp [concat $temp [lindex $vals $i]]
    prepend "{$temp}" medicineScreens
  }

  lappend eggScreens [loadImage assets/egg/egg1] [loadImage assets/egg/egg2]

  set baseBot [loadImage assets/babybot]
  set baseTop [loadImage assets/babytop]
  set baseGame [movePositionsHorizontal 2 $baseTop]

  set gameLeft [loadImage assets/game_left]
  set gameRight [loadImage assets/game_right]

  set gameArrowLeft [loadImage assets/game_arrow_left]
  set gameArrowRight [loadImage assets/game_arrow_right]

  set sun [loadImage assets/sun]

  set topGame [movePositionsVertical -1 $baseGame]
  set botGame [movePositionsHorizontal 2 $baseBot]
  set topGameOpen [lremove $topGame {21 20}]
  set topGameLose [loadImage assets/top_game_lose]
  set gameVs [loadImage assets/game_vs]

  set winScreens "{$botGame} {[concat $sun $topGameOpen]}"
  set loseScreens "{[concat [loadImage assets/small_cloud] $botGame]} {$topGameLose}"

  set gameWait "{$baseGame} {$topGame}"

  lappend babyScreens\
    $baseTop\
    [movePositionsHorizontal 2 $baseTop]\
    [movePositionsHorizontal 4 $baseTop]\
    [movePositionsHorizontal 6 $baseTop]\
    [movePositionsHorizontal 6 $baseBot]\
    [movePositionsHorizontal 8 $baseBot]\
    [movePositionsHorizontal 6 $baseBot]\
    [movePositionsHorizontal 4 $baseTop]\
    [movePositionsHorizontal 2 $baseTop]\
    $baseTop\
    [movePositionsHorizontal -2 $baseTop]\
    [movePositionsHorizontal -2 $baseBot]\
    [movePositionsHorizontal -4 $baseBot]\
    [movePositionsHorizontal -6 $baseBot]\
    [movePositionsHorizontal -6 $baseTop]\
    [movePositionsHorizontal -4 $baseTop]\
    [movePositionsHorizontal -2 $baseTop]

    set bread [loadImage assets/bread/bread1]
    set bread2 [loadImage assets/bread/bread2]
    set bread3 [loadImage assets/bread/bread3]
    set snack [loadImage assets/snack/snack1]
    set snack2 [loadImage assets/snack/snack2]
    set snack3 [loadImage assets/snack/snack3]
    set opened [loadImage assets/opened]

    lappend mealEatingScreens [concat [movePositionsVertical -8 $bread] $opened]\
                              [concat $bread $opened]\
                              [concat $bread2 $baseBot]\
                              [concat $bread2 $opened]\
                              [concat $bread3 $baseBot]\
                              [concat $bread3 $opened]\
                              $baseBot

    lappend snackEatingScreens [concat [movePositionsVertical -8 $snack] $opened]\
                               [concat $snack $opened]\
                               [concat $snack2 $baseBot]\
                               [concat $snack2 $opened]\
                               [concat $snack3 $baseBot]\
                               [concat $snack3 $opened]\
                               $baseBot


    set heart [loadImage assets/heart]
    set hearts {}
    for {set i 0} {$i < 4} {incr i} {
      set hearts [concat $hearts [movePositionsHorizontal [expr {-8*$i}] $heart]]
    }

    lappend meterImages "[loadImage assets/meter/meter1]"\
                        "[loadImage assets/meter/meter2]"\
                        "[concat [loadImage assets/meter/meter3] $hearts]"\
                        "[concat [loadImage assets/meter/meter4] $hearts]"

}

proc prepend {v l} {
  upvar $l lst
  set lst [concat $v $lst]
}

# Indices order is important...
proc lremove {lst indices} {
  for {set i 0} {$i < [llength $indices]} {incr i} {
    set index [lindex $indices $i]
    set lst [lreplace $lst $index $index]
  }
  return $lst
}

proc movePositionsHorizontal {n lst} {
  set res {}
  foreach element $lst {
    lappend res "[lindex $element 0] [expr {[lindex $element 1]+$n}]"
  }
  return $res
}

proc movePositionsVertical {n lst} {
  set res {}
  foreach element $lst {
    lappend res "[expr {[lindex $element 0]+$n}] [lindex $element 1]"
  }
  return $res
}

proc loadImage {fileName} {
  set fp [open $fileName r]
  set fd [read $fp]
  close $fp

  set result {}
  for {set i 0} {$i < [llength $fd]} {incr i 2} {
    lappend result "[lindex $fd $i] [lindex $fd [expr {$i+1}]]"
  }

  return $result
}

proc click {x y} {

  global console

  .can create oval 450 110 500 160 -outline purple -fill purple
  .can create oval 520 130 570 180 -outline purple -fill blue
  .can create oval 590 110 640 160 -outline purple -fill green

  if {$x > 450 && $x < 500 && $y > 110 && $y < 160} {
    $console select
  } elseif {$x > 520 && $x < 570 && $y > 130 && $y < 180} {
    $console execute
  } elseif {$x > 590 && $x < 640 && $y > 110 && $y < 160} {
    $console cancel
  } else {
    $console start
  }

}
