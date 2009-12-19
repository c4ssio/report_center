class Chart < ActiveRecord::Base
  has_many :chart_series
  has_many :chart_label
  has_many :series, :through=>:chart_series

  def create_file
    g=Gruff::Bar.new

    self.series.each do |s|
      series_name = s.name
      series_data_array = s.series_data_points.collect{|d| d.value}
      g.data(series_name,series_data_array )
    end

    self.attributes.select{|k,v| v.class != Time && k!='id'}.each do |k,v|
      g.send(k.to_s + '=',v) if v
    end
    
    new_file_name = 'public/images/test.png'

    g.write(new_file_name)

  end

  def add_series(name,data_array)
    new_series = Series.create(:name=>name)
    new_series.add_data_points(data_array)
    ChartSeries.create(:chart_id=>self.id,:series_id=>new_series.id)
  end

end
