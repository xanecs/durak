class Hand
  constructor: (@name, @cards, @size = 6, pack) ->
    @fill(pack) if pack

  eat: (cards) ->
    @cards.push.apply(@cards, cards)
    @cards

   remove: (card) ->
   	index = @cards.indexOf(card)
   	@cards.splice(index, 1) if index > -1

  fill: (pack) ->
    if @cards.length < @size
      @eat pack.take(@size - @cards.length)
    @cards

module.exports = Hand
