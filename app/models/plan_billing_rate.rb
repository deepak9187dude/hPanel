class PlanBillingRate < ActiveRecord::Base
  belongs_to :plan
  
  def current_plan_price(test)
    test=test.strip.to_s.strip
    if test=='monthly'
      self.monthly
    elsif test=='yearly'
      self.yearly
    elsif test== 'semi'
      self.semi
    elsif test== 'quaterly'
      self.quaterly
    end
  end
end
