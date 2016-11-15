get '/pixi' do
  respond Actions::Widgets::Search, template: :pixi
end
