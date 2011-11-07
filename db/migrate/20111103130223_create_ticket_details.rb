class CreateTicketDetails < ActiveRecord::Migration
  def self.up
    create_table :ticket_details do |t|
      t.integer :ticket_id
      t.integer  :replier_id    
      t.text  :reply
      t.text  :comments
      t.string  :status
      t.timestamps
    end
  end

  def self.down
    drop_table :ticket_details
  end
end
