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

ActiveRecord::Schema.define(:version => 20081206231429) do

  create_table "keyvalues", :force => true do |t|
    t.string   "key"
    t.string   "value"
    t.integer  "ping_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "phones", :force => true do |t|
    t.string   "name"
    t.integer  "home_ping_id"
    t.integer  "area_code_ping"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "number"
  end

  create_table "pings", :force => true do |t|
    t.string   "content"
    t.string   "address"
    t.string   "country"
    t.string   "locality"
    t.string   "thoroughfare"
    t.string   "postalcode"
    t.integer  "accuracy"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "message"
    t.integer  "phone_id"
    t.integer  "ping_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
    t.integer  "tid"
    t.string   "street_number"
    t.string   "twitter_username", :default => ""
    t.string   "animal_key",       :default => ""
  end

  create_table "placemarks", :force => true do |t|
    t.string   "name"
    t.integer  "ping_id"
    t.integer  "phone_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tiles", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
