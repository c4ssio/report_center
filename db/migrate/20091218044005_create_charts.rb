class CreateCharts < ActiveRecord::Migration
  def self.up
    create_table :charts do |t|
      t.string :title
      t.decimal :left_margin, :precision=>5, :scale=>2
      t.decimal :right_margin, :precision=>5, :scale=>2
      t.decimal :top_margin, :precision=>5, :scale=>2
      t.decimal :bottom_margin, :precision=>5, :scale=>2
      t.string :size, :length=>10
      t.decimal :minimum_value, :precision=>5, :scale=>2
      t.decimal :maximum_value, :precision=>5, :scale=>2
      t.integer :x_axis_increment
      t.integer :y_axis_increment
      t.string :x_axis_label
      t.string :y_axis_label
      t.string :marker_color
      t.timestamps
    end
  end

  def self.down
    drop_table :charts
  end
end
