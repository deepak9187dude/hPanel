class CreatePlanBillingRates < ActiveRecord::Migration
  def self.up
    create_table :plan_billing_rates do |t|
      t.integer   :plan_id
      t.float     :rec_monthly
      t.float     :rec_quaterly
      t.float     :rec_semiyear
      t.float     :rec_yearly
      t.integer   :monthly
      t.integer   :quaterly
      t.integer   :semi
      t.integer   :yearly
      t.integer   :active_plan
      t.timestamps
    end
  end

  def self.down
    drop_table :plan_billing_rates
  end
end
