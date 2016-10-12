get '/api' do
  respond Actions::Widgets::Search, :json
end
