module App::Models
  class Widget < Rote::Model
    alias_method :to_s, :name

    def validate
      validates_presence :name
      validates_unique :name
    end
  end
end
