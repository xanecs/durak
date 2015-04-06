Pack = require("./models/Pack.coffee")
Hand = require("./models/Hand.coffee")
Board = require("./models/Board.coffee")
Table = require("./models/Table.coffee")

prompt = require("prompt")
async = require("async")

pack = new Pack()
pack.shuffle()

table = new Table(pack)
console.log "Trump card: " + table.trump.toString()

async.eachSeries [1..4], (i, cb) ->
  prompt.get "name", (err, name) ->
    cb(err) if err

    if table.players.length == 0
      table.addPlayer(name.name, -1)
      return cb()

    if table.players.length == 1
      table.addPlayer(name.name, 0)
      return cb()

    if table.players.length > 1
      console.log "Sit right of:"
      for i in [1..table.players.length]
        console.log " " + i + " " + table.players[i-1].name
      prompt.get "choice", (err, rightOf) ->
        cb(err) if err
        table.addPlayer(name.name, rightOf.choice - 1)
        cb()
, (err) ->
  return console.log err if err
  console.log "Players:"
  for player in table.players
    console.log " - " + player.name
  move table, (err, res) ->
    console.log err if err
    console.log res.name + " won"

cardSelection = (hand, noopt, cb) ->
  console.log " 0 None" if noopt
  for i in [1..hand.cards.length]
    console.log " " + i + " " + hand.cards[i - 1].toString()
  prompt.get "choice", (err, attack) ->
    cb err if err
    if noopt and attack.choice == 0
      cb null, null
    cb null, hand.cards[attack.choice - 1]

attack = (board, secondary, cb) ->
  hand = board.attackerPrimary unless secondary
  hand = board.attackerSecondary if secondary
  console.log board.cards
  console.log hand.name + " attack with:"
  cardSelection hand, board.cards.length > 0, (err, card) ->
    cb err if err
    unless card
      return cb null, false
    if board.attack [card], hand
      cb null, true
    else
      console.log "Invalid Card"
      attack board, secondary, cb

defend = (board, cb) ->
  async.eachSeries board.cards, defendPair(board), (err) ->
    if err
      cb true
    else
      cb false

defendPair = (board) ->
  defendPairInner = (pair, cb) ->
    return cb null if pair.defense
    console.log "Defend " + pair.attack.toString() + " with:"
    cardSelection board.defendant, true, (err, card) ->
      cb err if err
      unless card
        board.setDefendantDone()
        return cb true
      else
        if board.defend pair, card
          return cb null
        else
          defendPairInner pair, cb
  defendPairInner

move = (table, cb) ->
  board = table.nextPlayers()
  console.log board.attackerPrimary.name + " attacks " + board.defendant.name
  console.log board.attackerSecondary.name + " helps."
  attackCycle = () ->
    attack board, false, (err, res) ->
      cb err if err
      unless res
        if board.setPrimaryDone()
          table.pointer++
          return move table, cb
      attack board, true, (err, res) ->
        unless res
          if board.setSecondaryDone()
            table.pointer++
            return move table, cb
        defend board, (res) ->
          for player in table.players
            if player.cards.length == 0
              return cb null, player
          if res
            move table, cb
          else
            attackCycle()
  attackCycle()