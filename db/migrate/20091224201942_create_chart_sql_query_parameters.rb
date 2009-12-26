class CreateChartSqlQueryParameters < ActiveRecord::Migration
  def self.up
    create_table :chart_sql_query_parameters do |t|
      t.integer :chart_id
      t.string :name #must match the parameter name in sql file
      t.string :text_value
      t.decimal :number_value, :precision=>15, :scale=>5
      t.timestamps
    end
  end

  def self.down
    drop_table :chart_sql_query_parameters
  end
end
