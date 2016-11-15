get '/vue' do
  respond Actions::Widgets::Search, template: :vue
end
