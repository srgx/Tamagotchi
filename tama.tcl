#!/usr/bin/tclsh

oo::class create Tamagotchi {

  constructor {} {
    variable age 0
    variable weight 5
    variable discipline 0
    variable hungry 1
    variable happy 1
  }
  
  method weight {} {
    variable weight
    return $weight
  }
  
}

oo::class create Console {

  constructor {} {
    variable currentOption 0
    variable options {none feed light game medicine bathroom meter discipline}
  }
  
  method showCurrentOption {} {
    variable currentOption
    variable options
    puts "Current option: [lindex $options $currentOption]"
  }
  
  # Left button
  method select {} {
    variable currentOption
    set currentOption [expr {($currentOption+1)%8}]
  }
  
  # Middle button
  method execute {} {
    
  }
  
  # Right button
  method cancel {} {
  }
  
  method mainLoop {} {
    variable tamagotchi
    for {set i 0} {$i < 4} {incr i} {
      puts [$tamagotchi weight]
    }
  }
  
  method hatch {} {
    for {set i 0} {$i < 4} {incr i} {
      puts "Egg..."
    }
    return [Tamagotchi new]
  }
  
  method paper {} {
    variable tamagotchi [my hatch]
    puts "Hello World!"
    my mainLoop
  }
  
}

set console [Console new]
$console paper
