class CreatePlans < ActiveRecord::Migration
  def self.up
    create_table :plans do |t|
      t.integer    :plan_billing_rates_id
      t.string     :title
      t.integer    :vps
      t.integer    :isavailable
      t.integer    :isdeleted
      t.timestamps
    end
  end

  def self.down
    drop_table :plans
  end
end
