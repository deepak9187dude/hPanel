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
   
    @plans.each do |plan|
      plan_billing_rates = nil

      plan_billing_rates = plan.plan_billing_rate
      if plan_billing_rates.monthly != 0
        row = Hash.new
        row['title'] =  plan.title
        row['rec_period'] =  plan_billing_rates.rec_monthly
        row['month'] = plan_billing_rates.monthly
        row['vps'] = plan.vps
        row['plan_id'] = plan.id
        row['period'] = "month"
        row['plan_type'] = "monthly"
        @plan_rows << row
      end

      if plan_billing_rates.quaterly != 0
        row = Hash.new
        row['title'] =  plan.title
        row['rec_period'] = plan_billing_rates.rec_quaterly
        row['month'] = 3
        row['vps'] = plan.vps
        row['plan_id'] = plan.id
        row['period'] = "months"
        row['plan_type'] = "quaterly"
        @plan_rows << row
      end

      if plan_billing_rates.semi != 0
        row = Hash.new
        row['title'] =  plan.title
        row['rec_period'] = plan_billing_rates.rec_semiyear
        row['month'] = 6
        row['vps'] =plan.vps
        row['plan_id'] =plan.id
        row['period'] ="months"
        row['plan_type'] = "semi"
        @plan_rows << row
      end

      if plan_billing_rates.yearly != 0
        row = Hash.new
        row['title'] =  plan.title
        row['rec_period'] = plan_billing_rates.rec_yearly
        row['month'] = 1
        row['vps'] =plan.vps
        row['plan_id'] =plan.id
        row['period'] ="year"
        row['plan_type'] = "yearly"
        @plan_rows << row
      end
    end
  end
  
  def signinh
    @user_title = {"Mr."=>"Mr.","Mrs."=>"Mrs.","Ms."=>"Ms."}
    @user = User.new    
    @type = params[:plantype]
    @plan_duration = Hash.new
    @plan_duration['yearly'] = 'Year'
    @plan_duration['monthly'] = 'Month'
    @plan_duration['semi'] = '6 Month'
    @plan_duration['quaterly'] = '3 Months'
    @plan = Plan.find(params[:plan_id],:include=>:plan_billing_rate)    
    @plan_rate = @plan.plan_billing_rate.current_plan_price(@type)
    
    session[:plan_id]=params[:plan_id]
    session[:plan_type]=@type
#    render :text => @plan_billing_rate.to_json
  end
  
  def payoptionsh
#    render :text => session.to_json
  end
end
