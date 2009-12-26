class CreateSqlQueries < ActiveRecord::Migration
  def self.up
    create_table :sql_queries do |t|
      t.string :name #name must match a sql file in the db/sql folder
      t.timestamps
    end
  end

  def self.down
    drop_table :sql_queries
  end
end
