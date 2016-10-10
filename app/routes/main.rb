require 'bundler'
Bundler.require(:default, :development)
require './app/config/sinatra'
require './app/config/sequel'

get '/' do
  logger.info "whatever"
  "Hello, world!"
end
