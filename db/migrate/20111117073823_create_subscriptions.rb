class CreateSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :subscriptions do |t|
      t.string  :name
      t.string  :status
      t.integer  :plan_id
      t.integer  :user_id
      t.timestamp  :end_date      
      t.timestamps
    end
  end

  def self.down
    drop_table :subscriptions
  end
end
