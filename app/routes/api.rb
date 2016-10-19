get '/api' do
  respond Actions::Widgets::Search, format: :json
end
