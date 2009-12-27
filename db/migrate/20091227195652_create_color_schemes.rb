class CreateColorSchemes < ActiveRecord::Migration
  def self.up
    create_table :color_schemes do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :color_schemes
  end
end
