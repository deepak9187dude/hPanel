class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.integer   :roles_id
      t.string    :username
      t.string    :password
      t.string    :title
      t.string    :first_name
      t.string    :last_name
      t.string    :email
      t.text      :address
      t.text      :address2
      t.string    :city
      t.integer   :state
      t.string    :state_other
      t.integer   :country
      t.string    :postal_code
      t.string    :account_type
      t.string    :company
      t.string    :phccode
      t.string    :phacode
      t.string    :phnumber
      t.string    :mccode
      t.string    :macode
      t.string    :mnumber
      t.string    :fccode
      t.string    :facode
      t.string    :fnumber
      t.timestamp :last_login
      t.string    :last_ip_used
      t.timestamp :registered_on
      t.string    :isreseller
      t.string    :status
      t.text      :description
      t.string    :authorize_code
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
