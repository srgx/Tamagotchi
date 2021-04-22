#!/usr/bin/wish

oo::class create Tamagotchi {

  constructor {} {
  
    variable age -1
    variable totalTime 0
    variable weight 5
    variable discipline 0
    variable hungry 1
    variable happy 1

    variable state normal
    
    variable eggScreens
    variable babyScreens
    variable mealEatingScreens
    variable snackEatingScreens

    variable frame 0

    variable screen

    my createEggscreens
    my createBabyScreens
    my createEatingScreens
    
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

  method createEatingScreens {} {

    variable mealEatingScreens
    variable snackEatingScreens

    set bread { {9 3} {9 4} {9 5} {9 6} {9 7} {9 8}
                {10 2} {10 7} {10 9}
                {11 2} {11 7} {11 9}
                {12 3} {12 6} {12 8}
                {13 3} {13 6} {13 8}
                {14 3} {14 6} {14 8}
                {15 3} {15 4} {15 5} {15 6} {15 7} {15 8} }

    set snack { {8 4}
                {9 3} {9 4}
                {10 2} {10 3} {10 4} {10 5} {10 6} {10 7}
                {11 4} {11 6} {11 7}
                {12 4} {12 5} {12 7}
                {13 4} {13 5} {13 6} {13 7} {13 8} {13 9}
                {14 7} {14 8}
                {15 7} }

    set opened { {8 12} {8 13}
                 {9 12} {9 13} {9 14} {9 15}
                 {10 13} {10 14} {10 15}
                 {11 14} {11 15} {11 16}
                 {12 14} {12 16}
                 {13 13} {13 14} {13 15} {13 16}
                 {14 11} {14 12} {14 13} {14 14} {14 15} }

    set baseBot { {13 12} {13 13} {13 14} {13 15}
                  {14 11} {14 13} {14 14} {14 16}
                  {15 10} {15 11} {15 12} {15 13} {15 14} {15 15} {15 16} {15 17} }


    set bread2 { {9 3}
                 {10 2} {10 4}
                 {11 2} {11 5} {11 6} {11 7} {11 8}
                 {12 3} {12 6} {12 8}
                 {13 3} {13 6} {13 8}
                 {14 3} {14 6} {14 8}
                 {15 3} {15 4} {15 5} {15 6} {15 7} {15 8} }

    set bread3 { {12 3} {12 4}
                 {13 3} {13 5} {13 6} {13 7} {13 8}
                 {14 3} {14 6} {14 8}
                 {15 3} {15 4} {15 5} {15 6} {15 7} {15 8} }



    set snack2 { {10 4} {10 5} {10 6} {10 7}
                 {11 4} {11 6} {11 7}
                 {12 4} {12 5} {12 7}
                 {13 4} {13 5} {13 6} {13 7} {13 8} {13 9}
                 {14 7} {14 8}
                 {15 7} }

    set snack3 { {12 5} {12 7}
                 {13 4} {13 5} {13 6} {13 7} {13 8} {13 9}
                 {14 7} {14 8}
                 {15 7} }


    set a [concat [movePositionsVertical -8 $bread] $opened]
    set b [concat $bread $opened]
    set c [concat $bread2 $baseBot]
    set d [concat $bread2 $opened]
    set e [concat $bread3 $baseBot]
    set f [concat $bread3 $opened]
    set g $baseBot

    lappend mealEatingScreens $a $b $c $d $e $f $g


    set a [concat [movePositionsVertical -8 $snack] $opened]
    set b [concat $snack $opened]
    set c [concat $snack2 $baseBot]
    set d [concat $snack2 $opened]
    set e [concat $snack3 $baseBot]
    set f [concat $snack3 $opened]
    set g $baseBot

    lappend snackEatingScreens $a $b $c $d $e $f $g

  }
  
  method createBabyScreens {} {
  
    variable babyScreens

    set baseTop { {9 12} {9 13} {9 14} {9 15}
                  {10 11} {10 13} {10 14} {10 16}
                  {11 11} {11 12} {11 13} {11 14} {11 15} {11 16}
                  {12 11} {12 12} {12 15} {12 16}
                  {13 11} {13 12} {13 13} {13 14} {13 15} {13 16}
                  {14 12} {14 13} {14 14} {14 15} }

    set baseBot { {13 12} {13 13} {13 14} {13 15}
                  {14 11} {14 13} {14 14} {14 16}
                  {15 10} {15 11} {15 12} {15 13} {15 14} {15 15} {15 16} {15 17} }


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

    lappend eggScreens\
      { {5 14} {5 15} {5 16} {5 17}\
        {6 13} {6 15} {6 16} {6 17} {6 18}\
        {7 12} {7 15} {7 16} {7 18} {7 19}\
        {8 12} {8 14} {8 15} {8 16} {8 19}\
        {9 11} {9 12} {9 13} {9 14} {9 15} {9 16} {9 17} {9 18} {9 19} {9 20}\
        {10 11} {10 12} {10 13} {10 14} {10 17} {10 18} {10 19} {10 20}\
        {11 11} {11 12} {11 13} {11 14} {11 17} {11 20}\
        {12 11} {12 14} {12 15} {12 16} {12 17} {12 19} {12 20}\
        {13 12} {13 15} {13 16} {13 17} {13 18} {13 19}\
        {14 13} {14 14} {14 15} {14 18}\
        {15 12} {15 13} {15 14} {15 15} {15 16} {15 17} {15 18} {15 19} }\
      { {5 14} {5 15} {5 16} {5 17}\
        {6 13} {6 16} {6 17} {6 18}\
        {7 12} {7 15} {7 16} {7 18} {7 19}\
        {8 12} {8 13} {8 14} {8 15} {8 16} {8 19}\
        {9 11} {9 12} {9 13} {9 14} {9 15} {9 16} {9 17} {9 19} {9 20}\
        {10 11} {10 12} {10 13} {10 14} {10 17} {10 18} {10 19} {10 20}\
        {11 11} {11 13} {11 14} {11 17} {11 20}\
        {12 11} {12 14} {12 15} {12 16} {12 17} {12 19} {12 20}\
        {13 12} {13 14} {13 15} {13 16} {13 17} {13 18} {13 19}\
        {14 13} {14 14} {14 15} {14 18}\
        {15 12} {15 13} {15 14} {15 15} {15 16} {15 17} {15 18} {15 19} }

  }
  
  method update {} {
  
    variable totalTime
    variable age
    variable screen
    variable frame
    variable state
  
    set cPhase [my phase]
    
    switch $cPhase {
    
      egg {
      
        puts Egg
      
        variable eggScreens
        set screen [lindex $eggScreens $frame]

        set frame [expr {1==$frame ? 0 : 1}]
        
      }
      
      baby {
      
        puts Baby

        if {$state=="normal"} {
          variable babyScreens
          set screen [lindex $babyScreens $frame]
          if {[incr frame] >= [llength $babyScreens]} { set frame 0 }
        } elseif {$state=="meal"} {
          variable mealEatingScreens
          set screen [lindex $mealEatingScreens $frame]
          if {[incr frame] >= [llength $mealEatingScreens]} { set state normal }
        } elseif {$state=="snack"} {
          variable snackEatingScreens
          set screen [lindex $snackEatingScreens $frame]
          if {[incr frame] >= [llength $snackEatingScreens]} { set state normal }
        }
      }
      
      child {
        puts Child
      }
      
    }
    
    if {[incr totalTime] == 10} { incr age }

  }

  method getImage {} {
    variable screen
    return $screen
  }
  
}

oo::class create Console {

  constructor {} {
  
    variable currentOption 0
    variable options {none feed light game medicine bathroom meter discipline}
    variable state off
    variable menuOption 0

    variable foodMenuScreens
    variable lightMenuScreens

    my createCanvas
    my createFoodMenuScreens
    my createLightMenuScreens
    
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

  method createLightMenuScreens {} {
    variable lightMenuScreens

    # 15 20

    set txt { {1 10} {1 11} {1 12} {1 17} {1 18} {1 22}
              {2 9} {2 13} {2 17} {2 19} {2 22}
              {3 9} {3 13} {3 17} {3 19} {3 22}
              {4 9} {4 13} {4 17} {4 20} {4 22}
              {5 9} {5 13} {5 17} {5 20} {5 22}
              {6 10} {6 11} {6 12} {6 17} {6 21} {6 22}
              {9 10} {9 11} {9 12} {9 15} {9 16} {9 17} {9 18}
              {9 20} {9 21} {9 22} {9 23}
              {10 9} {10 13} {10 15} {10 20}
              {11 9} {11 13} {11 15} {11 16} {11 17} {11 20} {11 21} {11 22}
              {12 9} {12 13} {12 15} {12 20}
              {13 9} {13 13} {13 15} {13 20}
              {14 10} {14 11} {14 12} {14 15} {14 20} }

    set arrow [my createArrow]

    lappend lightMenuScreens [concat $txt $arrow]
    lappend lightMenuScreens [concat $txt [movePositionsVertical 8 $arrow]]
  }

  method createArrow {} {
    return { {1 3}
                {2 3} {2 4}
                {3 1} {3 2} {3 3} {3 4} {3 5}
                {4 1} {4 2} {4 3} {4 4} {4 5} {4 6}
                {5 1} {5 2} {5 3} {5 4} {5 5}
                {6 3} {6 4}
                {7 3} }
  }

  method createFoodMenuScreens {} {

    variable foodMenuScreens

    set txt { {1 8} {1 9} {1 11} {1 12} {1 25}
            {2 8} {2 10} {2 12} {2 15} {2 16} {2 20} {2 21} {2 22} {2 25}
            {3 8} {3 10} {3 12} {3 14} {3 17} {3 22} {3 25}
            {4 8} {4 10} {4 12} {4 14} {4 15} {4 16} {4 17}
            {4 19} {4 20} {4 21} {4 22} {4 25}
            {5 8} {5 10} {5 12} {5 14} {5 19} {5 22} {5 25}
            {6 8} {6 10} {6 12} {6 15} {6 16} {6 17} {6 20}
            {6 21} {6 23} {6 25}
            {8 9} {8 10} {8 28}
            {9 8} {9 11} {9 28}
            {10 8} {10 13} {10 14} {10 15} {10 16} {10 19}
            {10 20} {10 21} {10 24} {10 25} {10 28}
            {11 9} {11 10} {11 13} {11 16} {11 21} {11 23} {11 26} {11 28} {11 30}
            {12 11} {12 13} {12 16} {12 18} {12 19} {12 20} {12 21} {12 23} {12 28} {12 29}
            {13 8} {13 11} {13 13} {13 16} {13 18} {13 21} {13 23} {13 26} {13 28} {13 30}
            {14 9} {14 10} {14 13} {14 16} {14 19} {14 20} {14 22} {14 24} {14 25}
            {14 28} {14 30} }

    set arrow [my createArrow]

    lappend foodMenuScreens [concat $txt $arrow]
    lappend foodMenuScreens [concat $txt [movePositionsVertical 8 $arrow]]

  }


  
  # Left button
  method select {} {

    puts "Selecting"
    variable currentOption
    variable options
    variable menuOption
    variable state
    variable foodMenuScreens
    variable lightMenuScreens

    if {$state=="on"||$state=="dark"} {

      set opt [lindex $options $currentOption]
      if {$opt != "none"} { .can itemconfigure  $opt -fill yellow }
      set currentOption [expr {($currentOption+1)%8}]
      set opt [lindex $options $currentOption]
      if {$opt != "none"} { .can itemconfigure  $opt -fill black }
      my showCurrentOption

    } elseif {$state=="foodmenu"} {

      my toggleMenuOption
      puts $menuOption
      my updateScreen [lindex $foodMenuScreens $menuOption]

    } elseif {$state=="lightmenu"} {

      my toggleMenuOption
      puts $menuOption
      my updateScreen [lindex $lightMenuScreens $menuOption]

    }

  }

  method toggleMenuOption {} {
    variable menuOption
    set menuOption [expr {$menuOption==0 ? 1 : 0}]
  }
  
  # Middle button
  method execute {} {

    variable currentOption
    variable options
    variable state
    variable foodMenuScreens
    variable lightMenuScreens
    variable menuOption
    variable tamagotchi

    set opt [lindex $options $currentOption]

    puts "Executing $opt"

    if {$state=="on"||$state=="dark"} {

      switch $opt {

        feed {
          set state foodmenu
          my updateScreen [lindex $foodMenuScreens 0]
        }

        light {
          set state lightmenu
          my updateScreen [lindex $lightMenuScreens 0]
        }

        default {
          #
        }

      }
    } elseif {$state=="lightmenu"} {

      if {$menuOption==0} {
        set state "on"
      } else {
        set state "dark"
        my blackScreen
      }

    } elseif {$state=="foodmenu"} {
      $tamagotchi eat $menuOption
      set state "on"
    }

    set menuOption 0

  }
  
  # Right button
  method cancel {} {
    variable state

    puts "Cancel"

    if {$state=="foodmenu" || $state=="lightmenu"} {
      set state on
    }

  }
  
  method update {} {
  
    variable state
    variable tamagotchi

    if {$state!="off"} { $tamagotchi update }
    if {$state=="on"} { my updateScreen [$tamagotchi getImage] }

  }

  method blackScreen {} {
    for {set i 0} {$i < 16} {incr i} {
      for {set j 0} {$j < 32} {incr j} {
        .can itemconfigure "$i-$j" -fill black -outline black
      }
    }
  }

  method updateScreen { scr } {
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
    variable state "on"
    variable tamagotchi [Tamagotchi new]
  }
  
}

proc every {ms body} {
  eval $body; after $ms [namespace code [info level 0]]
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
    $console paper
  }

}

set console [Console new]

every 500 {
  global console
  $console update
}
