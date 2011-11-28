class ChangeAmountCreditedToAmountCreditedInvoiceDetails < ActiveRecord::Migration
  def self.up
    rename_column :invoice_details, :amount_Credited, :amount_credited
  end

  def self.down
  end
end
