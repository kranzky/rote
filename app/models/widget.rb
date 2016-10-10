class Widget < Sequel::Model
  alias_method :to_s, :name
end
