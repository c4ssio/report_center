class ColorScheme < ActiveRecord::Base
  has_many :items, :class_name=>'ColorSchemeItem'
end
