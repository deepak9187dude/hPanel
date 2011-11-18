class AddTimePeriodToSubscriptions < ActiveRecord::Migration
  def self.up
    add_column :subscriptions, :billing_period, :integer
    add_column :subscriptions, :next_billing_period, :integer
  end

  def self.down
    remove_column :subscriptions, :billing_period
    remove_column :subscriptions, :next_billing_period
  end
end
