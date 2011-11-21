class CreateTickets < ActiveRecord::Migration
  def self.up
    create_table :tickets do |t|
      t.integer :user_id
      t.string  :priority
      t.string  :subject
      t.string  :category
      t.text    :comments
      t.string  :status
      t.boolean :isdelete,:default=>false
      t.string  :random
      t.integer :replies,:default=>0
      t.string  :replier  
      t.timestamps
    end
  end

  def self.down
    drop_table :tickets
  end
end
