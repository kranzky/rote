module App::Actions::Widgets
  class Search < RoteAction
    param :query, ''

    def handle
      perform "search widgets"
      build "Widgets::SearchResults"
    end

    def validate
#     validates_presence :query
#     validates_type String, :query
    end
  end
end
