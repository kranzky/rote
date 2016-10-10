require 'bundler'
Bundler.require(:default, :development)
require './app/config/sinatra'
require './app/config/sequel'

get '/' do
  STDERR.puts "whatever"
  "Hello, world!"
end
