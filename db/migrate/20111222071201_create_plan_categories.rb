class CreatePlanCategories < ActiveRecord::Migration
  def self.up
    create_table :plan_categories do |t|
      t.string        :category_name
      t.integer       :plan_type_id
      t.string        :short_desc
      t.string        :long_desc
      t.boolean       :active_flag       
      t.timestamps
    end
  end

  def self.down
    drop_table :plan_categories
  end
end
