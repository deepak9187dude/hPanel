class AddDefaultToInvoiceTypeGatewayPayStatus < ActiveRecord::Migration
  def self.up
    change_column_default("invoice_details", "gateway_pay_status", "failed")
  end

  def self.down
    change_column_default("invoice_details", "gateway_pay_status", null)
  end
end
