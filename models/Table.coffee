Hand = require("./Hand.coffee")
Board = require("./Board.coffee")

class Table
  players: new Array()
  pointer: -1

  constructor: (@pack) ->
    @trump = @pack.cards[0]

  addPlayer: (name, rightOf) ->
    player = new Hand(name, [], 6, @pack)
    @players.splice(rightOf + 1, 0, player)

  nextPlayers: () ->
    @pointer++
    attackerPrimary = @players[@pointer % @players.length]
    defendant = @players[(@pointer + 1) % @players.length]
    attackerSecondary = @players[(@pointer + 2) % @players.length]
    new Board(attackerPrimary, attackerSecondary, defendant, @pack, @trump)

module.exports = Table
