set :server, :puma
set :root, File.expand_path('.')
set :views, File.join(settings.root, 'app', 'templates')
set :public_folder, 'www'
set :logger, false
