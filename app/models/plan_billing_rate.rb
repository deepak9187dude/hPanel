class PlanBillingRate < ActiveRecord::Base
  belongs_to :plan
  
  def current_plan_price(test)
    test=test.strip.to_s.strip
    if test=='monthly'
      self.rec_monthly
    elsif test=='yearly'
      self.rec_yearly
    elsif test== 'semi'
      self.rec_semiyear
    elsif test== 'quaterly'
      self.rec_quaterly
    end
  end
end
