class ChartSeries < ActiveRecord::Base
  belongs_to :chart
  has_many :options, :class_name=>'ChartSeriesOption' do
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
  has_many :data_points, :class_name=>'ChartSeriesDataPoint' do
    def add(args)
      raise "Expected: Fixnum,Float, or Array" unless [
        Fixnum,Float,Array].include?(args.class)
      args=Array(args)
      new_member = nil
      args.each do |a|
          #find last category's order and increment 1
          new_order = (self.empty? ? 1 : self.last.order+1)
          new_member = self.create(:value=>a,:order=>new_order)
          new_member.options.add(:value=>a.to_s)
      end
      new_member
    end
    def remove(value)
      raise "Expected: Fixnum or Float" unless [
        Fixnum,Float].include?(value.class)
      member = self.find_by_value(value)
      member_order = member.order
      member.delete
      #decrement all after it
      self.select{|m| m.order>member_order}.each{|m| m.order-=1;m.save!}
      self
    end
  end
end
