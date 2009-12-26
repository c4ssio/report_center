class ChartSeriesDataPoint < ActiveRecord::Base
  belongs_to :chart_series
  has_many :options,:class_name=>'ChartSeriesDataPointOption' do
        def add(args)
      opt = nil
      args.each do |k,v|
        #try to find an option with this
        opt = self.find_by_name(k.to_s.downcase)
        if opt
          #if found, replace with new value
          opt.value = v.to_s
          opt.save!
        else
          #otherwise, create the option
          opt=self.create(:name=>k.to_s.downcase,:value=>v.to_s)
        end
      end
      opt
    end
    def remove(name)
      opt = self.find_by_name(name.to_s.downcase)
      opt.delete
      self
    end
  end
end
