class CreateAdminPlans < ActiveRecord::Migration
  def self.up
    create_table :admin_plans do |t|
      t.integer       :effplan_id    
      t.integer       :session_id
      t.integer       :ostemplate_id
      t.string        :title
      t.integer       :plan_category_id
      t.string        :short_desc
      t.string        :long_desc
      t.boolean       :isAvailable
      t.boolean       :root_access
      t.boolean       :isDeleted
      t.boolean       :plan_sell_option
      t.timestamps
    end
  end

  def self.down
    drop_table :admin_plans
  end
end
