module App::Views::Widgets
  class List < Rote::View
    template "widgets/list"
    local :widgets

    def title
      "Yeh these are the results"
    end

    def validate
      validates_not_null :widgets
      validates_type Array, :widgets
    end
  end
end
