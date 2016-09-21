require 'bundler'

Bundler.require(:default, :development)

configure do
  set :server, :puma
end

get '/' do
  "Hello, world!"
end
