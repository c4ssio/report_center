class CreateColorSchemeGroups < ActiveRecord::Migration
  def self.up
    create_table :color_scheme_groups do |t|
      t.string :name
      t.integer :color_scheme_id
      t.timestamps
    end
  end

  def self.down
    drop_table :color_scheme_groups
  end
end
