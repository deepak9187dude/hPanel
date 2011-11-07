class FrontController < ApplicationController
  layout "frontend"
  @show_slider = false
  def index
    @show_slider = true
    @title = ""
    
  end
  def pricing
    @title = "Pricing"
    @plans = Plan.find(:all)
    @plan_rows = Array.new
   
    for plan in @plans
      plan_billing_rates = nil 
      
      plan_billing_rates = plan.plan_billing_rate
      if plan_billing_rates.monthly != 0
        row = Hash.new
        row['title'] =  plan.title      
        row['rec_period'] =  plan_billing_rates.rec_monthly 
        row['month'] = plan_billing_rates.monthly
        row['vps'] = plan.vps
        row['plan_id'] = plan.id
        row['period'] = "monthly"
        @plan_rows << row
      end
      
      if plan_billing_rates.quaterly != 0
        row = Hash.new
        row['title'] =  plan.title
        row['rec_period'] = plan_billing_rates.rec_quaterly 
        row['month'] = plan_billing_rates.quaterly
        row['vps'] = plan.vps
        row['plan_id'] = plan.id
        row['period'] = "quaterly"
        @plan_rows << row
      end
      
      if plan_billing_rates.semi != 0
        row = Hash.new
        row['title'] =  plan.title
        row['rec_period'] = plan_billing_rates.rec_semiyear 
        row['month'] = plan_billing_rates.semi
        row['vps'] =plan.vps
        row['plan_id'] =plan.id
        row['period'] ="semi"
        @plan_rows << row
      end
      
      if plan_billing_rates.yearly != 0
        row = Hash.new
        row['title'] =  plan.title
        row['rec_period'] = plan_billing_rates.rec_yearly 
        row['month'] = plan_billing_rates.yearly
        row['vps'] =plan.vps
        row['plan_id'] =plan.id
        row['period'] ="yearly"
        @plan_rows << row
      end
    end    
  end
  def signinh
    @user = User.new    
    @type = params[:plantype]
    @plan_duration = Hash.new
    @plan_duration['yearly'] = 'Year'
    @plan_duration['monthly'] = 'Month'
    @plan_duration['semi'] = '6 Month'
    @plan_duration['quaterly'] = '3 Months'
    @plan = Plan.find(params[:plan_id],:include=>:plan_billing_rate)    
    @plan_rate = @plan.plan_billing_rate.current_plan_price(@type)
  
    
#    render :text => @plan_rate.to_json
  end
end
