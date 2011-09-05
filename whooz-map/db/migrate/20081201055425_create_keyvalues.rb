class CreateKeyvalues < ActiveRecord::Migration
  def self.up
    create_table :keyvalues do |t|
      t.string :key
      t.string :value
      t.references :ping

      t.timestamps
    end
  end

  def self.down
    drop_table :keyvalues
  end
end
