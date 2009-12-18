# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091218225346) do

  create_table "chart_labels", :force => true do |t|
    t.integer  "chart_id"
    t.integer  "order"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "chart_series", :force => true do |t|
    t.integer  "chart_id"
    t.integer  "series_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "charts", :force => true do |t|
    t.string   "title"
    t.decimal  "left_margin",      :precision => 5, :scale => 2
    t.decimal  "right_margin",     :precision => 5, :scale => 2
    t.decimal  "top_margin",       :precision => 5, :scale => 2
    t.decimal  "bottom_margin",    :precision => 5, :scale => 2
    t.string   "size"
    t.decimal  "minimum_value",    :precision => 5, :scale => 2
    t.decimal  "maximum_value",    :precision => 5, :scale => 2
    t.integer  "x_axis_increment"
    t.integer  "y_axis_increment"
    t.string   "x_axis_label"
    t.string   "y_axis_label"
    t.string   "marker_color"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entries", :force => true do |t|
    t.string   "Name"
    t.string   "Telephone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "series", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "series_data_points", :force => true do |t|
    t.integer  "series_id"
    t.decimal  "value",      :precision => 5, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
