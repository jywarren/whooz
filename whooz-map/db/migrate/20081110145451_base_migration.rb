class BaseMigration < ActiveRecord::Migration
  def self.up
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
    end

    create_table "placemarks", :force => true do |t|
      t.string   "name"
      t.integer  "ping_id"
      t.integer  "phone_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end

  def self.down
    drop_table "phones"
    drop_table "pings"
    drop_table "placemarks"
  end
end
