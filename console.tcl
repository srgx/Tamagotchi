
oo::class create Console {

  constructor {} {

    # Console variables
    variable frame 0
    variable screen
    variable currentOption 0
    variable options {none feed light game medicine bathroom meter discipline}

    # Game states
    # off, normal, dark, foodmenu, lightmenu
    # meal, snack, bathroom, medicine, meter, game
    variable state off
    variable menuOption 0

    # Tamagotchi game state
    # wait, direction, win, lose, score
    variable gameState {}
    variable gameRound 1
    variable playerPoints 0
    variable tamagotchiPoints 0
    variable gameDirection
    variable choice {}

    variable totalTime 0

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

    set a $xPos ; set b $yPos ; set c [expr {$squareSize+$a}] ; set d [expr {$squareSize+$yPos}]

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

  method showCurrentOption {} {
    variable currentOption
    variable options
    puts "Current option: [lindex $options $currentOption]"
  }

  # Left button
  method select {} {

    global foodMenuScreens
    global lightMenuScreens

    variable currentOption
    variable options
    variable menuOption
    variable state
    variable gameState

    # Select main option
    if {$state=="normal"||$state=="dark"} {

      set opt [lindex $options $currentOption]
      if {$opt != "none"} { .can itemconfigure  $opt -fill yellow }
      set currentOption [expr {($currentOption+1)%8}]
      set opt [lindex $options $currentOption]
      if {$opt != "none"} { .can itemconfigure  $opt -fill black }

    } elseif {$state=="game"&&$gameState=="wait"} {
      my chooseLeft
    } else {

      # Select in submenu
      switch $state {

        foodmenu {
          my toggleMenuOption
          my updateScreen [lindex $foodMenuScreens $menuOption]
        }

        lightmenu {
          my toggleMenuOption
          my updateScreen [lindex $lightMenuScreens $menuOption]
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

  method toggleMenuOption {} {
    variable menuOption
    set menuOption [expr {$menuOption == 0 ? 1 : 0}]
  }

  method game {} {

    variable frame
    variable state
    variable gameState
    variable gameDirection

    set frame 0
    set state game
    set gameState wait
    set gameDirection left

  }

  # Middle button
  method execute {} {

    global foodMenuScreens
    global lightMenuScreens

    variable currentOption
    variable options
    variable state
    variable menuOption
    variable tamagotchi
    variable gameState

    set opt [lindex $options $currentOption]

    if {$state=="normal"||$state=="dark"} {

      switch $opt {

        feed {
          set state foodmenu
          my updateScreen [lindex $foodMenuScreens 0]
        }

        light {
          set state lightmenu
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

      if {$menuOption==0} {
        set state "normal"
      } else {
        set state "dark"
        my blackScreen
      }

    } elseif {$state=="foodmenu"} {
      my eat $menuOption
    } elseif {$state=="game"&&$gameState=="wait"} {
      my chooseRight
      return
    }

    set menuOption 0

  }

  method chooseLeft {} {

    global gameArrowLeft

    variable gameState
    variable choice
    variable frame

    set choice left
    set frame 0

    my updateScreen [concat [my getFace] $gameArrowLeft]
    set gameState direction

  }

  method chooseRight {} {

    global gameArrowRight

    variable gameState
    variable choice
    variable frame

    set choice right
    set frame 0

    my updateScreen [concat [my getFace] $gameArrowRight]
    set gameState direction

  }

  method getFace {} {
    global gameRight
    global gameLeft
    variable gameDirection
    return [expr {$gameDirection=="right" ? $gameRight : $gameLeft}]
  }

  # Right button
  method cancel {} {

    variable state

    if {$state=="foodmenu" || $state=="lightmenu" || $state =="meter"} {
      set state normal
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

  method paper {} {
    variable state normal
  }

  method eat {n} {

    variable frame
    variable state

    set frame 0
    set state [expr {0 == $n ? "meal" : "snack"}]

  }

  method weight {} {
    variable weight
    return $weight
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

    if {$state=="bathroom"}  { return }

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
    variable gameState
    variable gameRound
    variable playerPoints
    variable tamagotchiPoints

    if {[incr frame] >= 20} {

      set frame 0

      if {[incr gameRound] > 5} {

        my updateScreen\
          [concat $gameVs\
            [movePositionsHorizontal -18 [my getNumberImage $playerPoints 8]]\
            [movePositionsHorizontal -3 [my getNumberImage $tamagotchiPoints 8]]]

        set playerPoints 0 ; set tamagotchiPoints 0 ; set gameRound 1
        set gameState score

      } else {
        set gameState wait
      }

      return 1

    } else {
      return 0
    }

  }

  method waitAndCheckWinner {} {

    variable frame
    variable gameDirection
    variable choice
    variable playerPoints
    variable tamagotchiPoints
    variable gameState

    if {[incr frame] >= 10} {
      set frame 0
      if {$gameDirection==$choice} {
        incr playerPoints
        set gameState win
      } else {
        incr tamagotchiPoints
        set gameState lose
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
    variable playerPoints
    variable tamagotchiPoints
    variable gameState

    if {$state!="off"} {

      incr totalTime

      switch [my phase] {

        egg {
          my updateScreen [lindex $eggScreens $frame]
          set frame [expr {1==$frame ? 0 : 1}]
        }

        baby {

          switch $state {

            normal {
              my updateScreen [my addSkull [my addDirts [lindex $babyScreens $frame]]]
              if {[incr frame] >= [llength $babyScreens]} { set frame 0 }
            }

            meal {
              my updateScreen [lindex $mealEatingScreens $frame]
              if {[incr frame] >= [llength $mealEatingScreens]} { set state normal }
            }

            snack {
              my updateScreen [lindex $snackEatingScreens $frame]
              if {[incr frame] >= [llength $snackEatingScreens]} { set state normal }
            }

            bathroom {
              my updateScreen [movePositionsHorizontal -2 $screen]
              incr frame
              if {$frame > 15} { set state normal }
            }

            medicine {
              my updateScreen [lindex $medicineScreens $frame]
              if {[incr frame] >= [llength $medicineScreens]} { set state normal }
            }

            game {

              switch $gameState {

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
                  if {[incr frame] >= 50} { set state normal }
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

    if {$state=="medicine"}  { return }

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

