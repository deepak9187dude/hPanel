class Plan < ActiveRecord::Base
  has_one :plan_billing_rate
end
