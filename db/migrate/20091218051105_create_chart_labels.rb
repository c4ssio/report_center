class CreateChartLabels < ActiveRecord::Migration
  def self.up
    create_table :chart_labels do |t|
      t.integer :chart_id
      t.integer :order
      t.string :value
      t.timestamps
    end
  end

  def self.down
    drop_table :chart_labels
  end
end
