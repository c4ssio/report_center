class CreateChartSeriesDataPoints < ActiveRecord::Migration
  def self.up
    create_table :chart_series_data_points do |t|
      t.integer :chart_series_id
      t.decimal :value, :precision=>15, :scale =>5
      t.integer :order
      t.timestamps
    end
  end

  def self.down
    drop_table :chart_series_data_points
  end
end
