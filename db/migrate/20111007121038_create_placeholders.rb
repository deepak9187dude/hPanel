class CreatePlaceholders < ActiveRecord::Migration
  def self.up
    create_table :placeholders do |t|
      t.integer :template_id
      t.string  :data
      t.string  :function
      t.timestamps
    end
  end

  def self.down
    drop_table :placeholders
  end
end
