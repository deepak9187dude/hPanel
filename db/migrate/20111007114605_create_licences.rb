class CreateLicences < ActiveRecord::Migration
  def self.up
    create_table :licences do |t|
      t.integer   :customer_id
      t.text      :code
      t.string    :key
      t.text      :user_key
      t.integer   :tot_vps
      t.integer   :tot_servers
      t.timestamp :activated_on
      t.timestamp :expired_on
      t.string    :status
      t.integer   :verified
      t.text      :macAddress
      t.timestamps
    end
  end

  def self.down
    drop_table :licences
  end
end
