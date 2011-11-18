class CreateStateMasters < ActiveRecord::Migration
  def self.up
    create_table :state_masters do |t|
      t.string :state_name, :null => false
      t.string :code_two, :null => false    
      t.integer :state_contry_id
      t.timestamps
    end
  end

  def self.down
    drop_table :state_masters
  end
end
