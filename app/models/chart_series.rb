class ChartSeries < ActiveRecord::Base
  belongs_to :chart
  has_many :options, :class_name=>'ChartSeriesOption' do
    def create_or_update_by_name_and_value(name,value)
      o=self.find_or_create_by_name(name)
      o.value=value
      o.save!
    end
  end
  has_many :data_points, :class_name=>'ChartSeriesDataPoint'
end
