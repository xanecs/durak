Suit = require("./Suit.coffee")

class Card
  @values: [6, 7, 8, 9, 10, "jack", "queen", "king", "ace"]
  constructor: (@suit, @value) ->

  toString: ->
    Card.values[@value] + " of " + @suit

module.exports = Card
