class Hand
  constructor: (@cards, @size = 6, pack) ->
    @fill(pack) if pack

  eat: (cards) ->
    @cards.push.apply(@cards, cards)
    @cards

  fill: (pack) ->
    if @cards.length < @size
      @eat pack.take(@size - @cards.length)
    @cards

module.exports = Hand
