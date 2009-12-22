class Series < ActiveRecord::Base
  has_one :chart_series
  has_many :series_data_points
  has_many :charts, :through=>:chart_series

  def add_data_points(args)
    args.each do |a|
      SeriesDataPoint.create(:series_id=>self.id,:value=>a)
    end
  end

  def self.create_from_sql(name,sql)
    #creates a series from a name and its appropriate sql

  end



end
