Suit = require("./Suit.coffee")
Card = require("./Card.coffee")

class Pack
  cards: []
  constructor: () ->
    suits = [Suit.clubs, Suit.hearts, Suit.diamonds, Suit.spades]

    for suit in suits
      for value in [0..Card.values.length - 1]
        @cards.push(new Card(suit, value))

  shuffle: () ->
    numCards = @cards.length
    while numCards > 0
      rnd = Math.floor(Math.random() * numCards--)
      tmp = @cards[numCards]
      @cards[numCards] = @cards[rnd]
      @cards[rnd] = tmp
    @cards

  take: (requested) ->
    output = []
    num = Math.min(requested, @cards.length)
    if num > 0
      for i in [1..num]
        output.push(@cards.pop())
    output

module.exports = Pack
