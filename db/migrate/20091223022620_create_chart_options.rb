class CreateChartOptions < ActiveRecord::Migration
  def self.up
    create_table :chart_options do |t|
      t.integer :chart_id
      t.string :name
      t.string :value
      t.timestamps
    end
  end

  def self.down
    drop_table :chart_options
  end
end
