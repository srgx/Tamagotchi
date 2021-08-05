oo::class create Game {

  constructor {} {

    # Tamagotchi game state
    # wait, direction, win, lose, score
    variable gameState wait

    variable gameRound 1
    variable playerPoints 0
    variable tamagotchiPoints 0
    variable gameDirection left
    variable choice {}

  }

  method validChoice {} {
    variable choice
    variable gameDirection
    return [expr {$choice==$gameDirection}]
  }

  method getFace {} {
    global gameRight
    global gameLeft
    variable gameDirection
    return [expr {$gameDirection=="right" ? $gameRight : $gameLeft}]
  }

  method getState {} {
    variable gameState
    return $gameState
  }

  method setState {st} {
    variable gameState
    set gameState $st
  }

  method incrPlayer {} {
    variable playerPoints
    incr playerPoints
  }

  method incrTamagotchi {} {
    variable tamagotchiPoints
    incr tamagotchiPoints
  }

  method getTamagotchiPoints {} {
    variable tamagotchiPoints
    return $tamagotchiPoints
  }

  method getPlayerPoints {} {
    variable playerPoints
    return $playerPoints
  }

  method nextRound {} {
    variable gameRound
    incr gameRound
    return $gameRound
  }

  method isWaiting {} {
    variable gameState
    return [expr {"wait"==$gameState}]
  }

  method setDirection {dir} {
    variable gameState
    variable choice
    set choice $dir
    set gameState direction
  }

}
