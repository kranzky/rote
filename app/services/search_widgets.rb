module App::Services
  class SearchWidgets < Rote::Service
    argument :query, ''
    result :widgets, []

    def perform
      super
      self.widgets = Models::Widget.all
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
