class Board
  @cards = []
  @defenseCards = []
  @doneCount = 0

  constructor: (@attackerPrimary, @attackerSecondary, @defendant, @trump)

  attack: (cards) ->
    if @cards.length == 0
      for card in cards
        @cards.push
          attack: card
          defense: null
    else
      values = []
      for card in @attackCards
        values.push card.value

      for card in cards
        unless card.value == value
          return false

      for card in cards
        @cards.push
          attack: card
          defense: null

  defend: (id, defenseCard) ->
    attack = @cards[id]
    if defenseCard.suit == @trump.suit
      if attack.attack.suit == @trump.suit
        if defenseCard.value > attack.attack.value
          attack.defense = defenseCard
          return true
        else
          return false
      else
        attack.defense = defenseCard
        return true
    else
      if defenseCard.suit == attack.attack.suit
        if defenseCard.value > attack.attack.value
          attack.defense = defenseCard
          return true
        else
          return false
      else
        return false
  done: ->
    doneCount += 1

    if doneCount >= 3
      defeated = true
      cards = []
      for attack in @cards
        cards.push attack.attack
        cards.push attack.defense
        unless defense
          defeated = false

      unless defeated
        @defendant.eat cards
