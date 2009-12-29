class SqlQuery < ActiveRecord::Base
  has_many :sql_params, :class_name=>'SqlQueryParameter'
  has_many :charts
  after_create :add_defaults


  def add_defaults
    #make sure xml folder is created under public/data for serving up chart data
    FileUtils.mkdir_p(Rails.root.to_s + '/public/data/' + self.name)
  end
  def self.execute(sql_str)
    #this runs ActiveRecord::connection.execute for multiple statement
    #sql string, by parsing at semicolons, and returns the last result.
    #we need to do this because rails ships with multiple statements
    #disallowed by default, and this is a more conspicuous way to
    #invoke them only when necessary.
    r=nil
    sql_str.split(";").each do |q|
      r=ActiveRecord::Base.connection.execute(q) if q.length>0
    end
    r
  end
end
