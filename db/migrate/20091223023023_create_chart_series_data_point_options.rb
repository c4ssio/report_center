class CreateChartSeriesDataPointOptions < ActiveRecord::Migration
  def self.up
    create_table :chart_series_data_point_options do |t|
      t.integer :chart_series_data_point_id
      t.string :name
      t.string :value
      t.timestamps
    end
  end

  def self.down
    drop_table :chart_series_data_point_options
  end
end
