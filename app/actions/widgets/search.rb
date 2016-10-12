module App::Actions::Widgets
  class Search < Rote::Action
    param :query, ''

    def respond
      perform "search widgets"
      render "Widgets::List"
    end

    def validate
      validates_not_null :query
      validates_type String, :query
      validates_length_range 0..8, :query
    end
  end
end
