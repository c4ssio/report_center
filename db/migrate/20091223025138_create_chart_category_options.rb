class CreateChartCategoryOptions < ActiveRecord::Migration
  def self.up
    create_table :chart_category_options do |t|
      t.integer :chart_category_id
      t.string :name
      t.string :value
      t.timestamps
    end
  end

  def self.down
    drop_table :chart_category_options
  end
end
