class CreateServerMasters < ActiveRecord::Migration
  def self.up
    create_table :server_masters do |t|
      t.string :hostname
      t.integer :max_vps
      t.string  :root_password
      t.integer :vps_count
      t.string  :server_type
      t.string  :ip
      t.string  :subnet
      t.string  :gateway
      t.string  :ssh
      t.string  :status
      t.string  :file_system
      t.integer :architecture
      t.integer :admin_id
      t.timestamps
    end
  end

  def self.down
    drop_table :server_masters
  end
end
