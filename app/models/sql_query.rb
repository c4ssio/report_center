class SqlQuery < ActiveRecord::Base
  has_many :sql_params, :class_name=>'SqlQueryParameter'
  has_many :charts
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
