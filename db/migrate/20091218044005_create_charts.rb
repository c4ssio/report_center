class CreateCharts < ActiveRecord::Migration
  def self.up
    create_table :charts do |t|
      t.integer :parent_id
      t.integer :color_scheme_id
      t.integer :sql_query_id
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :charts
    #delete all xml files
  end
end
