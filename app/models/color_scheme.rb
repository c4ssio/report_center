class ColorScheme < ActiveRecord::Base
  belongs_to :color_scheme_group
  has_many :items, :class_name=>'ColorSchemeItem'
end
