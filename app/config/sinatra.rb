configure do
  set :server, :puma
  set :root, File.expand_path('.')
  set :views, File.join(settings.root, 'app', 'templates')
  file = File.new("#{settings.root}/log/#{settings.environment}.log", 'a+')
  file.sync = true
  use Rack::CommonLogger, file
  enable :reloader
end
