module App::Views::Widgets
  class SearchResults < RoteView
    template :index
    local :widgets, []

    def validate
      validates_not_null :widgets
      validates_type Array, :widgets
    end
  end
end
