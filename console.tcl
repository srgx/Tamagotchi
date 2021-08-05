#source "game.tcl"

oo::class create Console {

  constructor {} {

    # Console variables
    variable totalTime 0
    variable frame 0
    variable screen
    variable optionIndex 0
    variable options {none feed light game medicine bathroom meter discipline}

    # Game states
    # off, on, dark, foodmenu, lightmenu
    # meal, snack, bathroom, medicine, meter, game
    variable state off

    # Submenu choice for food and light(0 or 1)
    variable menuOptionIndex 0

    # Object containing game data
    variable gameObject

    # Tamagotchi parameters
    variable age -1
    variable weight 5
    variable discipline 0
    variable hungry 2
    variable happy 3
    variable dirt 0
    variable sick 0

    my createCanvas

  }

  method createCanvas {} {

    canvas .can
    .can configure -width 854
    .can configure -height 480

    pack .can
    wm title . "Tama"

    set numRows 16
    set numCols 32

    set squareSize 12

    set xPos 40
    set yPos 70

    set a $xPos ; set b $yPos
    set c [expr {$squareSize+$a}] ; set d [expr {$squareSize+$yPos}]

    for {set i 0} {$i < $numRows} {incr i} {

      for {set j 0} {$j < $numCols} {incr j} {
        .can create rect $a $b $c $d -outline black -fill red -tags "$i-$j"
        set a [expr {$a+$squareSize}]
        set c [expr {$c+$squareSize}]
      }

      set a $xPos
      set c [expr {$squareSize+$a}]
      set b [expr {$b+$squareSize}]
      set d [expr {$d+$squareSize}]

    }

    # Control buttons
    .can create oval 450 110 500 160 -outline purple -fill purple
    .can create oval 520 130 570 180 -outline purple -fill blue
    .can create oval 590 110 640 160 -outline purple -fill green

    # Icons
    .can create oval 40 10 90 60 -outline purple -fill yellow -tag feed
    .can create oval 140 10 190 60 -outline purple -fill yellow -tag light
    .can create oval 240 10 290 60 -outline purple -fill yellow -tag game
    .can create oval 340 10 390 60 -outline purple -fill yellow -tag medicine

    .can create oval 40 270 90 320 -outline purple -fill yellow -tag bathroom
    .can create oval 140 270 190 320 -outline purple -fill yellow -tag meter
    .can create oval 240 270 290 320 -outline purple -fill yellow -tag discipline
    .can create oval 340 270 390 320 -outline purple -fill yellow -tag attention

    bind . <1> {click %x %y}

  }

  # Left button
  method select {} {

    global foodMenuScreens
    global lightMenuScreens

    variable optionIndex
    variable options
    variable state

    # Select main option
    if {$state=="on"||$state=="dark"} {

      set opt [lindex $options $optionIndex]
      if {$opt != "none"} { .can itemconfigure  $opt -fill yellow }
      set optionIndex [expr {($optionIndex+1)%8}]
      set opt [lindex $options $optionIndex]
      if {$opt != "none"} { .can itemconfigure  $opt -fill black }

    } elseif {[my isGameWaiting]} {
      my chooseLeft
    } else {

      # Select in submenu
      switch $state {

        foodmenu {
          my toggleMenu $foodMenuScreens
        }

        lightmenu {
          my toggleMenu $lightMenuScreens
        }

        meter {
          my toggleMeter
        }

        default {
          #
        }

      }

    }

  }

  method isGameWaiting {} {
    variable gameObject
    variable state
    return [expr {$state=="game"&&[$gameObject isWaiting]}]
  }

  method toggleMenu {screens} {
    variable menuOptionIndex
    my togglemenuOptionIndex
    my updateScreen [lindex $screens $menuOptionIndex]
  }

  method togglemenuOptionIndex {} {
    variable menuOptionIndex
    set menuOptionIndex [expr {$menuOptionIndex == 0 ? 1 : 0}]
  }

  method game {} {

    variable frame
    variable state
    variable gameObject

    set frame 0
    set state game
    set gameObject [Game new]

  }

  # Middle button
  method execute {} {

    global foodMenuScreens
    global lightMenuScreens

    variable optionIndex
    variable menuOptionIndex
    variable options
    variable state
    variable gameObject

    if {$state=="on"||$state=="dark"} {

      switch [lindex $options $optionIndex] {

        feed {
          set state foodmenu
          set menuOptionIndex 0
          puts zerowanie
          my updateScreen [lindex $foodMenuScreens 0]
        }

        light {
          set state lightmenu
          set menuOptionIndex 0
          puts zerowanie
          my updateScreen [lindex $lightMenuScreens 0]
        }

        medicine {
          my medicine
        }

        bathroom {
          my bathroom
        }

        meter {
          my meter
        }

        game {
          my game
        }

        default {
          #
        }

      }
    } elseif {$state=="lightmenu"} {

      if {$menuOptionIndex==0} {
        set state "on"
      } else {
        set state "dark"
        my blackScreen
      }

    } elseif {$state=="foodmenu"} {
      my eat $menuOptionIndex
    } elseif {[my isGameWaiting]} {
      my chooseRight
      return
    }

  }

  method chooseLeft {} {
    my setDirection left
  }

  method chooseRight {} {
    my setDirection right
  }

  method setDirection {dir} {

    global gameArrowLeft
    global gameArrowRight

    variable gameObject
    variable frame

    set frame 0
    $gameObject setDirection $dir
    my updateScreen [concat [$gameObject getFace]\
                    [expr {$dir=="right" ? $gameArrowRight : $gameArrowLeft}]]

  }

  # Right button
  method cancel {} {

    variable state

    if {$state=="foodmenu" || $state=="lightmenu" || $state =="meter"} {
      set state on
    }

  }

  method blackScreen {} {
    for {set i 0} {$i < 16} {incr i} {
      for {set j 0} {$j < 32} {incr j} {
        .can itemconfigure "$i-$j" -fill black -outline black
      }
    }
  }

  method updateScreen { scr } {

    # Keep screen in memory
    variable screen $scr

    for {set i 0} {$i < 16} {incr i} {
      for {set j 0} {$j < 32} {incr j} {
        if {"$i $j" in $scr} {
          .can itemconfigure "$i-$j" -fill black -outline black
        } else {
          .can itemconfigure "$i-$j" -fill white -outline white
        }
      }
    }

  }

  method start {} {
    variable state on
  }

  method eat {n} {

    variable frame
    variable state

    set frame 0
    set state [expr {0 == $n ? "meal" : "snack"}]

  }

  method phase {} {

    variable age

    if {$age < 0} {
      return egg
    } elseif {$age < 1} {
      return baby
    } else {
      return child
    }

  }

  method bathroom {} {

    global waveImage
    variable state
    variable frame
    variable screen
    variable dirt

    set dirt 0
    set frame 0
    set state bathroom

    my updateScreen [concat $screen $waveImage]

  }

  method getNumberImage {n shift} {
    global digits
    set len [string length $n]
    set wimage {}
    for {set i [expr {$len-1}]} {$i >= 0} {incr i -1} {
      set wimage [concat $wimage [movePositionsVertical $shift [movePositionsHorizontal [expr {-5*($len-$i-1)}] [lindex $digits [string index $n $i]]]]]
    }
    return $wimage
  }

  method fillHearts { scr n } {
    global heartInside
    for {set i 0} {$i < $n} {incr i} {
      set scr [concat [movePositionsHorizontal [expr {$i*8}] $heartInside] $scr]
    }
    return $scr
  }

  method toggleMeter {} {

    global meterImages

    variable frame
    variable weight
    variable age
    variable hungry
    variable happy

    set frame [expr {($frame+1)%4}]
    set localScreen [lindex $meterImages $frame]

    switch $frame {

      0 {
        set localScreen [concat [my getNumberImage $weight 8]\
                        [concat [my getNumberImage $age 0] $localScreen]]
      }

      2 {
        set localScreen [my fillHearts $localScreen $hungry]
      }

      3 {
        set localScreen [my fillHearts $localScreen $happy]
      }

      default {
      }

    }

    my updateScreen $localScreen

  }

  method addDirts {scr} {
    global dirtImage
    variable dirt
    if {$dirt >= 1} { set scr [concat $scr $dirtImage ] }
    if {$dirt >= 2} { set scr [concat $scr [movePositionsHorizontal -17 $dirtImage ] ] }
    return $scr
  }


  method nextRound {} {

    global gameVs

    variable frame
    variable gameObject

    if {[incr frame] >= 20} {

      set frame 0

      if {[$gameObject nextRound] > 5} {

        my updateScreen\
          [concat $gameVs\
            [movePositionsHorizontal -18 [my getNumberImage [$gameObject getPlayerPoints] 8]]\
            [movePositionsHorizontal -3 [my getNumberImage [$gameObject getTamagotchiPoints] 8]]]

        $gameObject setState score

      } else {
        $gameObject setState wait
      }

      return 1

    } else {
      return 0
    }

  }

  method waitAndCheckWinner {} {

    variable frame
    variable gameObject

    if {[incr frame] >= 10} {
      set frame 0
      if {[$gameObject validChoice]} {
        $gameObject incrPlayer
        $gameObject setState win
      } else {
        $gameObject incrTamagotchi
        $gameObject setState lose
      }
    }

  }

  method update {} {

    global eggScreens
    global babyScreens
    global mealEatingScreens
    global snackEatingScreens
    global medicineScreens
    global gameWait
    global winScreens
    global loseScreens

    variable totalTime
    variable age
    variable frame
    variable state
    variable screen
    variable gameObject

    if {$state!="off"} {

      incr totalTime

      switch [my phase] {

        egg {
          my updateScreen [lindex $eggScreens $frame]
          set frame [expr {1==$frame ? 0 : 1}]
        }

        baby {

          switch $state {

            on {
              my updateScreen [my addSkull [my addDirts [lindex $babyScreens $frame]]]
              if {[incr frame] >= [llength $babyScreens]} { set frame 0 }
            }

            meal {
              my updateScreen [lindex $mealEatingScreens $frame]
              if {[incr frame] >= [llength $mealEatingScreens]} { set state on }
            }

            snack {
              my updateScreen [lindex $snackEatingScreens $frame]
              if {[incr frame] >= [llength $snackEatingScreens]} { set state on }
            }

            bathroom {
              my updateScreen [movePositionsHorizontal -2 $screen]
              incr frame
              if {$frame > 15} { set state on }
            }

            medicine {
              my updateScreen [lindex $medicineScreens $frame]
              if {[incr frame] >= [llength $medicineScreens]} { set state on }
            }

            game {

              switch [$gameObject getState] {

                wait {
                  if {[incr frame] >= [llength $gameWait]} { set frame 0 }
                  my updateScreen [lindex $gameWait $frame]
                }

                direction {
                  my waitAndCheckWinner
                }

                win {
                  if {![my nextRound]} {
                    my updateScreen\
                      [lindex $winScreens [expr {$frame % [llength $winScreens]}]]
                  }
                }

                lose {
                  if {![my nextRound]} {
                    my updateScreen\
                      [lindex $loseScreens [expr {$frame % [llength $loseScreens]}]]
                  }
                }

                score {
                  if {[incr frame] >= 30} { set gameObject {} ; set state on }
                }

                default {
                }

              }

            }

            default {
            }

          }

        }

        child {
        }

      }

      if {$totalTime == 10} { incr age }
      if {$totalTime == 80} { my newDirt }
      if {$totalTime == 100} { my newDirt }
      if {$totalTime == 120 } { my makeSick }

    }

  }

  method addSkull {scr} {
    global skullImage
    variable sick
    if {$sick} { set scr [concat $scr $skullImage] }
    return $scr
  }

  method makeSick {} {
    variable sick
    set sick 1
  }

  method newDirt {} {
    variable dirt
    incr dirt
  }

  method medicine {} {

    variable state
    variable frame
    variable sick

    set sick 0
    set frame 0
    set state medicine

  }

  method meter {} {

    global meterImages
    variable frame
    variable state
    variable age
    variable weight

    set state meter
    set frame 0
    my updateScreen [concat [my getNumberImage $weight 8]\
                            [concat [my getNumberImage $age 0]\
                                    [lindex $meterImages $frame]]]

  }

}

