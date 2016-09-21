require 'bundler'
Bundler.require(:default, :development)
require './config/sinatra'

get '/' do
  "Hello, world!"
end
