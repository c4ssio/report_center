class CreateChartCategories < ActiveRecord::Migration
  def self.up
    create_table :chart_categories do |t|
      t.integer :chart_id
      t.string :name
      t.integer :order
      t.timestamps
    end
  end

  def self.down
    drop_table :chart_categories
  end
end
