require 'sinatra'

configure do
  set :server, :puma
end

get '/' do
  "Hello, world!"
end
