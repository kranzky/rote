set :server, :puma
set :root, File.expand_path('.')
set :views, File.join(settings.root, 'app', 'templates')
set :public_folder, File.join(settings.root, 'www')
set :logger, false
set :haml, { escape_html: false }

require "sinatra/reloader" if development?
['actions', 'models', 'policies', 'services', 'views'].each do |dir|
  Dir.glob("#{settings.root}/app/#{dir}/**/*.rb").each do |path|
    also_reload path
  end
end
