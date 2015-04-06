class Board
  cards: new Array()
  defenseCards: new Array()
  primaryDone: false
  secondaryDone: false
  defendantDone: false

  constructor: (@attackerPrimary, @attackerSecondary, @defendant, @pack, @trump) ->
    console.log @attackerPrimary.name + " (" + @attackerSecondary.name + ") vs. " + @defendant.name

  attack: (cards, hand) ->
    console.log hand.name + " attacks with:"
    for card in cards
      console.log " - " + card.toString()

    unless hand == @attackerPrimary or hand == @attackerSecondary
      return false

    if @cards.length == 0
      unless hand == @attackerPrimary
        return false
      value = cards[0].value
      for card in cards
        unless card.value == value
          return false
    else
      values = []
      for card in @cards
        values.push card.attack.value
        values.push card.defense.value if card.defense

      for card in cards
        unless values.indexOf(card.value) > -1
          return false

    for card in cards
      hand.remove(card)
      @cards.push
        attack: card
        defense: null
    @primaryDone = @secondaryDone = @defendantDone = false
    console.log "allowed"
    return true

  defend: (id, defenseCard) ->
    attack = @cards[@cards.indexOf id]
    console.log @defendant.name + " defends " + attack.attack.toString() + " with " + defenseCard.toString()
    if defenseCard.suit == @trump.suit
      if attack.attack.suit == @trump.suit
        unless defenseCard.value > attack.attack.value
          attack.defense = defenseCard
          return false
    else
      if defenseCard.suit == attack.attack.suit
        unless defenseCard.value > attack.attack.value
          return false
      else
        return false
    attack.defense = defenseCard
    @defendant.remove(defenseCard)
    @primaryDone = @secondaryDone = @defendantDone = false
    console.log "successful"
    return true

  setPrimaryDone: ->
    @primaryDone = true
    @finalize()

  setSecondaryDone: ->
    @secondaryDone = true
    @finalize()

  setDefendantDone: ->
    @defendantDone = true
    @finalize()

  finalize: ->
    if @primaryDone and @secondaryDone or @defendantDone
      defeated = true
      cards = []
      for attack in @cards
        cards.push attack.attack
        cards.push attack.defense if attack.defense
        unless attack.defense
          defeated = false

      if (not defeated) or @defendantDone
        @defendant.eat cards
            
      @attackerPrimary.fill(@pack)
      @attackerSecondary.fill(@pack)
      @defendant.fill(@pack)
      @cards = []
      return true
    else
      return false

module.exports = Board