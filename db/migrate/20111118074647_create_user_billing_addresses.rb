class CreateUserBillingAddresses < ActiveRecord::Migration
  def self.up
    create_table :user_billing_addresses do |t|
      t.integer   :user_id
      t.text      :address
      t.text      :address2
      t.string    :city
      t.integer   :state
      t.string    :state_other
      t.integer   :country
      t.string    :postal_code
      t.string    :phccode
      t.string    :phacode
      t.string    :phnumber
      t.string    :phextension
      t.timestamps
   end
  end

  def self.down
    drop_table :user_billing_addresses
  end
end
