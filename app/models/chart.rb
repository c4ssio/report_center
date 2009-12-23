class Chart < ActiveRecord::Base
  has_many :series, :class_name=>'ChartSeries' do
    def add(args)
      raise "Expected: Symbol,String or Array" unless [
        Symbol,Array,String].include?(args.class)
      args=Array(args)
      new_member = nil
      args.each do |s|
        #ignore if already exists
        new_member=self.find_by_name(s.to_s.downcase)
        unless new_member
          #find last one's order and increment 1
          new_order = (self.empty? ? 1 : self.last.order+1)
          new_member = self.create(:name=>s.to_s.downcase,:order=>new_order)
          new_member.options.add(:seriesname=>s.to_s)
        end
      end
      new_member
    end
    def remove(name)
      raise "Expected: Symbol or String" unless [
        Symbol,String].include?(name.class)
      ch_s = self.find_by_name(name.to_s.downcase)
      ch_s_order = ch_s.order
      ch_s.delete
      #decrement all after it
      self.select{|c| c.order>ch_s_order}.each{|sa| sa.order-=1;sa.save!}
    self
    end
  end

  has_many :categories, :class_name=>'ChartCategory' do
    def add(args)
      raise "Expected: Symbol,String or Array" unless [
        Array,String,Symbol].include?(args.class)
      args=Array(args)
      new_member = nil
      args.each do |c|
        #ignore if already exists
        new_member = self.find_by_name(c.to_s.downcase)
        unless new_member
          #find last one's order and increment 1
          new_order = (self.empty? ? 1 : self.last.order+1)
          new_member = self.create(:name=>c.to_s.downcase,:order=>new_order)
          new_member.options.add(:name=>c.to_s)
        end
      end
      new_member
    end
    def remove(name)
      raise "Expected: Symbol or String" unless [
        Symbol,String].include?(name.class)
      ch_cat = self.find_by_name(name.to_s.downcase)
      ch_cat_order = ch_cat.order
      ch_cat.delete
      #decrement all after it
      self.select{|c| c.order>ch_cat_order}.each{|ca| ca.order-=1;ca.save!}
      self
    end
  end

  has_many :options, :class_name=>'ChartOption' do
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
