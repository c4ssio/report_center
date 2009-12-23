class CreateChartSeriesOptions < ActiveRecord::Migration
  def self.up
    create_table :chart_series_options do |t|
      t.integer :chart_series_id
      t.string :name
      t.string :value
      t.timestamps
    end
  end

  def self.down
    drop_table :chart_series_options
  end
end
