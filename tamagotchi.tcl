
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

    # normal, meal, snack, bathroom
    variable state normal

    variable eggScreens
    variable babyScreens
    variable mealEatingScreens
    variable snackEatingScreens

    variable frame 0

    variable screen

    variable skullImage [loadImage assets/skull]
    variable waveImage [loadImage assets/wave]
    variable dirtImage [loadImage assets/dirt]

    my createEggscreens
    my createBabyScreens

  }

  method createBabyScreens {} {
    set baseBot [loadImage assets/babybot]
    my createBabyWalkScreens $baseBot
    my createEatingScreens $baseBot
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

  method createEatingScreens {baseBot} {

    variable mealEatingScreens
    variable snackEatingScreens

    set bread [loadImage assets/bread]
    set bread2 [loadImage assets/bread2]
    set bread3 [loadImage assets/bread3]
    set snack [loadImage assets/snack]
    set snack2 [loadImage assets/snack2]
    set snack3 [loadImage assets/snack3]
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

  }

  method createBabyWalkScreens {baseBot} {

    variable babyScreens

    set baseTop [loadImage assets/babytop]

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

  }

  method createEggscreens {} {
    variable eggScreens
    lappend eggScreens [loadImage assets/egg1] [loadImage assets/egg2]
  }


  method bathroom {} {

    variable state
    variable frame
    variable screen
    variable dirt
    variable waveImage

    if {$state=="bathroom"}  { return }

    set dirt 0
    set frame 0
    set state bathroom

    set screen [concat $screen $waveImage]

  }

  method addDirts {scr} {
    variable dirt
    variable dirtImage
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

        variable eggScreens
        set screen [lindex $eggScreens $frame]

        set frame [expr {1==$frame ? 0 : 1}]

      }

      baby {

        if {$state=="normal"} {
          variable babyScreens
          set screen [my addSkull [my addDirts [lindex $babyScreens $frame]]]
          if {[incr frame] >= [llength $babyScreens]} { set frame 0 }
        } elseif {$state=="meal"} {
          variable mealEatingScreens
          set screen [lindex $mealEatingScreens $frame]
          if {[incr frame] >= [llength $mealEatingScreens]} { set state normal }
        } elseif {$state=="snack"} {
          variable snackEatingScreens
          set screen [lindex $snackEatingScreens $frame]
          if {[incr frame] >= [llength $snackEatingScreens]} { set state normal }
        } elseif {$state=="bathroom"} {
          puts xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
          set screen [movePositionsHorizontal -2 $screen]
          incr frame
          if {$frame > 15} {
            set state normal
          }
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
    variable sick
    variable skullImage
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
