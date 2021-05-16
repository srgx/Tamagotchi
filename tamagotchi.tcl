
oo::class create Tamagotchi {

  constructor {} {

    variable age -1
    variable totalTime 0
    variable weight 5
    variable discipline 0
    variable hungry 1
    variable happy 1
    variable dirt 0
    variable sick 0

    # normal, meal, snack, bathroom, medicine, meter
    variable state normal

    variable frame 0
    variable screen

  }

  method eat {n} {

    variable frame
    variable state

    set frame 0

    if {$n==0} {
      set state meal
    } elseif {$n==1} {
      set state snack
    }

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

    set screen [concat $screen $waveImage]

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

  method getNumber {n shift} {
    global digits
    set len [string length $n]
    set wimage {}
    for {set i [expr {$len-1}]} {$i >= 0} {incr i -1} {
      set wimage [concat $wimage [movePositionsVertical $shift [movePositionsHorizontal [expr {-5*($len-$i-1)}] [lindex $digits [string index $n $i]]]]]
    }
    return $wimage
  }

  method meter {} {

    global digits
    global meterImages
    variable frame
    variable screen
    variable state
    variable age
    variable weight

    set state meter
    set frame 0
    set screen [concat [my getNumber $weight 8] [concat [my getNumber $age 0] [lindex $meterImages $frame]]]

  }

  method normal {} {
    variable state
    set state normal
  }

  method toggleMeter {} {

    variable frame
    global meterImages
    variable screen
    variable weight
    variable age

    set frame [expr {($frame+1)%4}]
    set screen [lindex $meterImages $frame]

    if {0==$frame} {
      set screen [concat [my getNumber $weight 8]\
                         [concat [my getNumber $age 0] $screen]]
    }

    return $screen

  }

  method addDirts {scr} {
    global dirtImage
    variable dirt
    if {$dirt >= 1} { set scr [concat $scr $dirtImage ] }
    if {$dirt >= 2} { set scr [concat $scr [movePositionsHorizontal -17 $dirtImage ] ] }
    return $scr
  }

  method update {} {

    variable totalTime
    variable age
    variable screen
    variable frame
    variable state

    set cPhase [my phase]

    puts [my phase]

    switch $cPhase {

      egg {

        global eggScreens
        set screen [lindex $eggScreens $frame]
        set frame [expr {1==$frame ? 0 : 1}]

      }

      baby {

        if {$state=="normal"} {
          global babyScreens
          set screen [my addSkull [my addDirts [lindex $babyScreens $frame]]]
          if {[incr frame] >= [llength $babyScreens]} { set frame 0 }
        } elseif {$state=="meal"} {
          global mealEatingScreens
          set screen [lindex $mealEatingScreens $frame]
          if {[incr frame] >= [llength $mealEatingScreens]} { set state normal }
        } elseif {$state=="snack"} {
          global snackEatingScreens
          set screen [lindex $snackEatingScreens $frame]
          if {[incr frame] >= [llength $snackEatingScreens]} { set state normal }
        } elseif {$state=="bathroom"} {
          set screen [movePositionsHorizontal -2 $screen]
          incr frame
          if {$frame > 15} {
            set state normal
          }
        } elseif {$state=="medicine"} {
          global medicineScreens
          set screen [lindex $medicineScreens $frame]
          if {[incr frame] >= [llength $medicineScreens]} { set state normal }
        }

      }

      child {
        #
      }

    }

    if {[incr totalTime] == 10} { incr age }
    if {$totalTime == 120 } { my makeSick }
    if {$totalTime == 80} { my newDirt }
    if {$totalTime == 100} { my newDirt }

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

  method getImage {} {
    variable screen
    return $screen
  }

}
