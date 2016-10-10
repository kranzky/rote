require 'bundler'
Bundler.require(:default, :development)

require './app/config/all'
require './app/models/all'

get '/' do
  logger.info "whatever"
  "Hello, world!"
end
