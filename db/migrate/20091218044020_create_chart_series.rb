class CreateChartSeries < ActiveRecord::Migration
  def self.up
    create_table :chart_series do |t|
      t.integer :chart_id
      t.integer :series_id
      t.timestamps
    end
  end

  def self.down
    drop_table :chart_series
  end
end
