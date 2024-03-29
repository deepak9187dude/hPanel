class CreateGateways < ActiveRecord::Migration
  def self.up
    create_table :gateways do |t|
      t.string      :gateway
      t.string      :gateway_login
      t.string      :gateway_key
      t.boolean     :isEnabled     
      t.timestamps
    end
  end

  def self.down
    drop_table :gateways
  end
end
