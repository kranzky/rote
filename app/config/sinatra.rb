configure do
  set :server, :puma
  set :root, File.expand_path('.')
  file = File.new("#{settings.root}/log/#{settings.environment}.log", 'a+')
  file.sync = true
  use Rack::CommonLogger, file
end
