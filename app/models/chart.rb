class Chart < ActiveRecord::Base
  has_many :chart_series
  has_many :chart_label
  has_many :series, :through=>:chart_series

  def add_series(name,data_array)
    new_series = Series.create(:name=>name)
    new_series.add_data_points(data_array)
    ChartSeries.create(:chart_id=>self.id,:series_id=>new_series.id)
  end

end
