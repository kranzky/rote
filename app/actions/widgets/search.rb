module App::Actions::Widgets
  class Search < RoteAction
    param :query, ''

    def handle
      perform "search widgets"
      render "Widgets::SearchResults"
    end

    def validate
      validates_not_null :query
      validates_type String, :query
      validates_length_range 0..8, :query
    end
  end
end
