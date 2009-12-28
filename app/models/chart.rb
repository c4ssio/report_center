class Chart < ActiveRecord::Base
  belongs_to :sql_query
  has_many :sql_params, :class_name=>'ChartSqlQueryParameter'
  belongs_to :parent, :class_name=>'Chart', :foreign_key=>:parent_id
  has_many :children, :class_name=>'Chart', :foreign_key=>:parent_id

  has_many :series, :class_name=>'ChartSeries' do
    def add_or_reorder(string_array)
      #this method reorders members m of the series by matching to
      #supplied string_array
      string_array.each do |s|
        s_i=string_array.index(s)
        s_m=self.find_by_name(s)
        if s_m
          #reorder found series member
          s_m.order=s_i+1
          s_m.save!
        else
          #create a series and option at this position
          self.create(:name=>s,:order=>s_i+1).options.create(
            :name=>'seriesname',:value=>s)
        end
      end

      #remaining series members should be sorted
      #at the end of the array
      r_m_i=string_array.length+1

      self.reject{|m|
        string_array.include?(m.name)
      }.sort_by(&:order).each do |r_s_m|
        r_s_m.order=r_m_i
        r_s_m.save!
        r_m_i+=1
      end
    end
  end

  has_many :categories, :class_name=>'ChartCategory' do
    def add_or_reorder(string_array)
      #this method reorders members m of the category by matching to
      #supplied string_array
      string_array.each do |s|
        c_i=string_array.index(s)
        c_m=self.find_by_name(s)
        if c_m
          #reorder found category member
          c_m.order=c_i+1
          c_m.save!
        else
          #create a category and option at this position
          self.create(:name=>s,:order=>c_i+1
          ).options.create(:name=>'name',:value=>s)
        end
      end

      #remaining category members should be sorted
      #at the end of the array
      r_m_i=string_array.length+1

      self.reject{|m|
        string_array.include?(m.name)
      }.sort_by(&:order).each do |r_c_m|
        r_c_m.order=r_m_i
        r_c_m.save!
        r_m_i+=1
      end
    end
  end

  has_many :options, :class_name=>'ChartOption' do
    def create_or_update_by_name_and_value(name,value)
      o=self.find_or_create_by_name(name)
      o.value=value
      o.save!
    end
  end

  after_create :add_default_options

  def add_default_options
    #default chart options
    #(should be moved to the database once we define
    #methods for a "default chart"
    {:xaxisname=>'', :yaxisname=>'',
      :caption=>'',:lineThickness=>'1', :animation=>'1',
      :showNames=>'1', :alpha=>'100',:showLimits=>'1', :decimalPrecision=>'1',
      :rotateNames=>'1', :numDivLines=>'3',:limitsDecimalPrecision=>'0',
      :showValues=>'0'}.each do |n,v|
      self.options.find_or_create_by_name_and_value(n.to_s,v)
    end
  end

  def add_color_scheme(cs_name)
    cs = ColorScheme.find_by_name(cs_name)
    #takes a color scheme and applies all members to its series in order
    color_array = cs.items.collect(&:hex_code)
    c_i = 0
      self.series.each do |s|
        #if the series is named "other," skips it and applies a gray pattern
        if s.name=='other'
          new_color = 'C0C0C0' 
        else
          new_color = color_array[c_i]
          c_i+=1
        end
        s.options.create_or_update_by_name_and_value('color',new_color)
      end
  end

  def load_from_sql
    #regenerates data based on currently defined sql and parameters
    #existing category and series names and options are left alone;
    #new ones are added with no options.
    #data points are added with whatever options the first one has,
    #under the assumption that all data points have the same options

    #load sql file into string
    sql_str = File.open(
      "#{Rails.root}/db/sql/#{self.sql_query.name}.sql",'r').read
    #replace sql string parameters
    
    self.sql_params.each do |sqlp|
      sql_str.gsub!("@#{sqlp.name}",
        sqlp.text_value ? "'#{sqlp.text_value}'" : sqlp.number_value.to_s
      )
    end
    result = SqlQuery.execute(sql_str)
    #feed result set into 2d array, with
    #series, category, data point as columns
    data_array = Array.new
    r_i = 0
    result.each do |r|
      #puts "r_i=#{r_i.to_s};c_i=#{c_i.to_s};r=#{r}"
      data_array[r_i]=r
      r_i+=1
    end
    #get series and category in correct order
    #and apply this order to current series, if any
    series_array = data_array.collect{|c| c[0]}
    self.series.add_or_reorder(series_array)
    category_array = data_array.collect{|c| c[1]}
    self.categories.add_or_reorder(category_array)
    #turn each data_point into a hash coordinate
    #this will make it easier to iterate through
    #the series and category arrays to ensure we've
    #entered all necessary data points in correct order
    data_hash = Hash.new
    prior_series_name = nil
    data_array.each do |dp|
      series_name = dp[0]
      category_name = dp[1]
      if series_name != prior_series_name
        #start new series
        data_hash[series_name]=Hash.new
      end
      data_hash[series_name][category_name] = dp[2]
      prior_series_name = series_name
    end
    #iterate through categories and series and ensure that
    #all combinations are accounted for; those that are not
    #found in the hash are created and given zero values
    self.series.each do |s|
      #get options from first existing datapoint, if any  
      new_dp_options=
        s.data_points[0].options.reject{|o|
        o.name=='value'}.clone unless s.data_points.empty?
      #clear all data points in this series
      s.data_points.each(&:delete)
      s.save!
      #add a datapoint for each category
      d_i=1
      self.categories.each do |c|
        new_dp=s.data_points.find_or_create_by_value_and_order(
          #set to zero if not found
          data_hash[s.name][c.name] || 0,
          d_i
        )
        new_dp.options = new_dp_options if new_dp_options
        #add value option
        new_dp.options.find_or_create_by_name_and_value(
          "value",new_dp.value
        )
        new_dp.save!
        d_i+=1
      end if data_hash[s.name]
    end
  end

  def to_fcxml
    #generates xml file for the chart and saves its data in the data
    #folder
    sorted_categories=nil
    sorted_series=nil
    xml = Builder::XmlMarkup.new(:indent=>0)
    graph_options=Hash.new
    self.options.each{|cho|
      graph_options[cho.name.to_sym] = cho.value.to_s
    }
    xml.graph(graph_options) do
      category_options=Hash.new
      xml.categories do
        sorted_categories = self.categories.sort_by(&:order)
        sorted_categories.each{|c|
          c.options.each do |co|
            category_options[co.name.to_sym]=co.value.to_s
          end
          xml.category(category_options)
        }
      end
      self.series.sort_by(&:order).each do |s|
        dataset_options=Hash.new
        s.options.each{|so|
          dataset_options[so.name.to_sym]=so.value.to_s
        }
        xml.dataset(dataset_options) do
          set_options=Hash.new
          sorted_data = s.data_points.sort_by(&:order)
          sorted_data.each{|dp|
            d_i = sorted_data.index(dp)
            #if the chart has children, links and parameters
            #should be attached to the datapoints
            set_options[:link]="javascript:getChildCharts('#{self.sql_query.name}','#{
            s.name}','#{sorted_categories[d_i].name}');" unless self.children.empty?
            dp.options.each do |dpo|
              set_options[dpo.name.to_sym]=dpo.value.to_s
            end
            xml.set(set_options)
          }
        end
      end
    end

    File.open(Rails.root.to_s + "/public/data/" + self.name + ".xml","w") {|f|
      f.write(xml.target!)
    }
  end



end
