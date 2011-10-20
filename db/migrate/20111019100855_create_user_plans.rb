class CreateUserPlans < ActiveRecord::Migration
  def self.up
    create_table :user_plans do |t|
      t.integer      :user_id
      t.integer      :plan_id
      t.float        :fraudScore
      t.string       :billingperiod
      t.timestamp    :insertTS
      t.integer      :plan_current_status
      t.timestamps
    end
  end

  def self.down
    drop_table :user_plans
  end
end
