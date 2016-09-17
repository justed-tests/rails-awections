var AuctionSocket = window.AuctionSocket = function (userId, auctionId, form) {
  this.userId = userId
  this.auctionId = auctionId
  this.form = $(form)

  this.socket = new WebSocket(App.websocket_url + 'auctions/' + this.auctionId)
  this.initBinds()
}

AuctionSocket.prototype.initBinds = function () {
  var _this = this

  this.form.submit(function (e) {
    e.stopPropagation()
    e.preventDefault()
    _this.sendBid($('#bid_value').val())
  })

  this.socket.onmessage = function (e) {
    var tokens = e.data.split(' ')
    console.log(e)

    switch (tokens[0]) {
      case 'bidok':
        _this.bid(tokens[1])
        break
      case 'underbid':
        _this.underbid(tokens[1])
        break
      case 'outbid':
        _this.outbid(tokens[1])
        break
      case 'won':
        _this.won()
        break
      case 'lost':
        _this.lost()
        break
    }
  }
}

AuctionSocket.prototype.sendBid = function (value) {
  this.value = value
  var template = 'bid {{auctionId}} {{userId}} {{value}}'
  this.socket.send(Mustache.render(template, {
    userId: this.userId,
    auctionId: this.auctionId,
    value: value
  }))
}

AuctionSocket.prototype.bidok = function () {
  this.form.find('.message strong').html(
    'Your bid ' + this.value
  )
}

AuctionSocket.prototype.outbid = function (value) {
  this.form.find('.message strong').html(
    'Your bid is under ' + value + '.'
  )
}

AuctionSocket.prototype.underbid = function (value) {
  this.form.find('.message strong').html(
    'You were underbid. It is now ' + value + '.'
  )
}

AuctionSocket.prototype.won = function () {
  this.form.find('.message strong').html(
    'You won! ' + this.value + '.'
  )
}

AuctionSocket.prototype.lost = function () {
  this.form.find('.message strong').html(
    'You lost the auction'
  )
}
