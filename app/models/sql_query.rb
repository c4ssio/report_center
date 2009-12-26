class SqlQuery < ActiveRecord::Base
  has_many :sql_params, :class_name=>'SqlQueryParameter'
  has_many :charts
end
