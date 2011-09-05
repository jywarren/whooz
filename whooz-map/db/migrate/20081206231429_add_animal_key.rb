class AddAnimalKey < ActiveRecord::Migration
  def self.up
    add_column :pings, :animal_key, :string, :default => ""
  end

  def self.down
    remove_column :pings, :animal_key
  end
end
