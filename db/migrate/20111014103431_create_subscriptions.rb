class CreateSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :subscriptions do |t|
      t.string    :name
      t.integer   :hosting_id
      t.integer   :hosting_plan_id
      t.string    :account_name
      t.string    :status,:default=>'Active'
      t.timestamp  :start_date,:default=>Time.now
      t.timestamp  :end_date
      t.integer   :grace_period,:default=>15
      t.timestamps
    end
  end

  def self.down
    drop_table :subscriptions
  end
end
