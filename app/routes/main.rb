get '/' do
  respond Actions::Widgets::Search
end

get '/other' do
  respond Actions::Widgets::Search, template: :other
end
