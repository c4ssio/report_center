class CreateColorSchemeItems < ActiveRecord::Migration
  def self.up
    create_table :color_scheme_items do |t|
      t.integer :color_scheme_id
      t.string :hex_code
      t.timestamps
    end
  end

  def self.down
    drop_table :color_scheme_items
  end
end
