class ChartSeriesDataPoint < ActiveRecord::Base
  belongs_to :chart_series
  has_many :options,:class_name=>'ChartSeriesDataPointOption'
end
