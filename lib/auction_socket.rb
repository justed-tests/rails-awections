require File.expand_path '../place_bid.rb', __FILE__
# classic sockets
class AuctionSocket
  def initialize(app)
    @app = app
    @clients = []
  end

  def call(env)
    @env = env

    if socket_request?
      socket = spawn_socket
      @clients << socket
      socket.rack_response
    else
      @app.call(env)
    end
  end

  private

  attr_reader :env

  def socket_request?
    Faye::WebSocket.websocket? env
  end

  def spawn_socket
    socket = Faye::WebSocket.new env
    socket.on :open do
      socket.send 'Hello'
    end

    socket.on :message do |event|
      begin
        tokens = event.data.split ' '
        operation = tokens.delete_at 0

        case operation
        when 'bid' then bid socket, tokens
        end
      rescue StandardError => e
        p e
        p e.backtrace
      end
    end
    socket
  end

  def bid(socket, tokens)
    auction = Auction.find(tokens[0])
    value = tokens[2]
    service = PlaceBid.new(
      value:   value,
      user:    User.find(tokens[1]),
      auction: auction
    )

    if service.execute
      socket.send 'bidok'
      notify_outbids socket, value
    else
      if service.status == :won
        notify_auction_ended socket
      else
        socket.send "underbid #{auction.current_bid}"
      end
    end
  end

  def notify_outbids(socket, val)
    @clients.reject { |c| c == socket || !same_auction?(c, socket) }.each do |cl|
      cl.send "outbid #{val}"
    end
  end

  def notify_auction_ended(socket)
    socket.send 'won'

    @clients.reject { |c| c == socket || !same_auction?(c, socket) }.each do |cl|
      cl.send 'lost'
    end
  end

  def same_auction?(other, socket)
    other.env['REQUEST_PATH'] == socket.env['REQUEST_PATH']
  end
end
