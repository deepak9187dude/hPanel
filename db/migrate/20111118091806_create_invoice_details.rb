class CreateInvoiceDetails< ActiveRecord::Migration
  def self.up
    create_table :invoice_details do |t|
      t.integer     :plan_id
      t.integer     :user_id
      t.integer     :cc_id
      t.string      :gateway_trans_type      
      t.string      :gateway_pay_status
      t.datetime    :gateway_trans_time
      t.string      :gateway_description
      t.string      :cc_trans_id
      t.integer     :profile_id
      t.float       :amount_Credited
      t.datetime    :payment_date
      t.string      :payment_description
      t.integer     :payment_status
      t.integer     :invoice_type_id
      t.datetime    :next_due_date
      t.float       :amount_debited
      t.float       :additional_credit
      t.string      :subscription_status
      t.string      :transaction_type
      t.datetime    :pay_success_date
      t.integer     :gateway_id
      t.integer     :basic_invoice
      t.integer     :pay_mode 
      t.timestamps
    end
  end

  def self.down
    drop_table :invoice_details
  end
end
