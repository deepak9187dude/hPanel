class CreateVms < ActiveRecord::Migration
  def self.up
    create_table :vms do |t|
      t.integer   :server_id
      t.integer   :ip_id
      t.integer   :user_id
      t.integer   :invoice_details_id
      t.string    :name
      t.string    :display_name
      t.string    :template
      t.string    :ram
      t.string    :hdd
      t.string    :diskinodes
      t.string    :burst_ram
      t.string    :lvg
      t.string    :host_name
      t.string    :config_file
      t.string    :password
      t.integer   :port
      t.integer   :numprocess
      t.integer   :cpu_units
      t.string    :contact_email
      t.string    :status
      t.string    :type
      t.string    :creation_status
      t.timestamps
    end
  end

  def self.down
    drop_table :vms
  end
end
