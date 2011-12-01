class AddSubscriptionIdToInvoiceDetails < ActiveRecord::Migration
  def self.up
    add_column :invoice_details, :subscription_id, :integer
  end

  def self.down
    remove_column :invoice_details, :subscription_id
  end
end