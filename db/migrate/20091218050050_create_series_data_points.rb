class CreateSeriesDataPoints < ActiveRecord::Migration
  def self.up
    create_table :series_data_points do |t|
      t.integer :series_id
      t.decimal :value, :precision=>5, :scale=>2
      t.timestamps
    end
  end

  def self.down
    drop_table :series_data_points
  end
end
