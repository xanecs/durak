Pack = require("./models/Pack.coffee")
Hand = require("./models/Hand.coffee")

pack = new Pack()
pack.shuffle()

trump = pack.take(1)[0]

playerOne = new Hand([], 6, pack)
playerTwo = new Hand([], 6, pack)
playerThree = new Hand([], 6, pack)
playerFour = new Hand([], 6, pack)

console.log "Trump card: " + trump.toString()

console.log "Player One:"
console.log " - " + card.toString() for card in playerOne.cards

console.log "Player Two:"
console.log " - " + card.toString() for card in playerTwo.cards

console.log "Player Three:"
console.log " - " + card.toString() for card in playerThree.cards

console.log "Player Four:"
console.log " - " + card.toString() for card in playerFour.cards
