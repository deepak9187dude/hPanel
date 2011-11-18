class CreateCcdata < ActiveRecord::Migration
  def self.up
    create_table :ccdata do |t|
      t.integer     :user_id
      t.string      :first_name
      t.string      :last_name
      t.string      :card_num
      t.string      :cnumber
      t.integer     :exp_month
      t.integer     :exp_year
      t.integer     :cvv
      t.string      :cc_type  
      t.boolean     :isUserAccAddress
      t.text        :address
      t.text        :address2
      t.string      :city
      t.integer     :state
      t.string      :state_other
      t.integer     :country
      t.string      :postal_code
      t.string      :phccode
      t.string      :phacode
      t.string      :phnumber
      t.string      :phextension
      t.boolean     :isActive
      t.timestamps
    end
  end

  def self.down
    drop_table :ccdata
  end
end
