require_relative 'boot'
require File.expand_path('../../lib/auction_socket.rb', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

module Awections
  # main app class
  class Application < Rails::Application
    config.sass.preferred_syntax = :sass
    config.middleware.use AuctionSocket
  end
end
