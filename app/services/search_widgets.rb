module App::Services
  class SearchWidgets < RoteService
    argument :query, ''
    result :widgets, []

    def perform
      self.widgets = App::Models::Widget.all
      true
    end

    def validate_arguments
      validates_not_null :query
      validates_type String, :query
    end

    def validate_results
      validates_not_null :widgets
      validates_type Array, :widgets
    end
  end
end
