class ChartCategory < ActiveRecord::Base
  belongs_to :chart
  has_many :options, :class_name=>'ChartCategoryOption' do
    def add(args)
      raise "Expected: Hash" unless args.class==Hash
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
      raise "Expected: Symbol or String" unless [
        Symbol,String].include?(name.class)
      opt = self.find_by_name(name.to_s.downcase)
      opt.delete
      self
    end
  end
end
