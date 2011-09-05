class AddTwitterUsername < ActiveRecord::Migration
  def self.up
    add_column :pings, :twitter_username, :string, :default => ""
  end

  def self.down
    remove_column :pings, :twitter_username
  end
end
