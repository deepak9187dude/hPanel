	class AdminBillingsController < ApplicationController
  layout 'admin_backend'   
  before_filter :admin_current_user

  def hosting_plans    
      @hosting_plans = AdminPlan.all
  end
  
  def receivables
    @receivable_type = params[:receivable]
    case @receivable_type
    when "orders"
      @receivables = ""
      @receivable_navigation = "Orders"
    when "pending"
      @receivables = ""
      @receivable_navigation = "Pending orders"
    when "completed"
      @receivables = ""
      @receivable_navigation = "Completed orders"
    when "cancelled"
      @receivables = ""
      @receivable_navigation = "Cancelled orders"
    when "requests"
      @receivables = ""
      @receivable_navigation = "Payment Requests/Failed Payments "
      render "payment_requests"
    else
      @receivables = ""
      @receivable_navigation = ""
    end
  end
  
  def anti_fraud_checklist
    
  end
  
  def gateway_settings
      @gateway_settings = Gateway.all
  end
  
  def fraud_score
      @fraud_score = FraudScore.first
  end
  
  def add_fraud_score
      @fraud_score = FraudScore.find(params[:id]) if params[:id]
  end
  
  def configure_gateway
      @gateway_configuration = Gateway.find(params[:id]) if params[:id]
  end
  
  def gateway_update
      @gateway_configuration = Gateway.find(params[:id]) if params[:id]
      @gateway_configuration.update_attributes(params[:gateway_configuration]) 
      redirect_to gateway_settings_path
  end

  def fraud_score_update
      @fraud_score = FraudScore.find(params[:id]) if params[:id]
      @fraud_score.update_attributes(params[:fraud_score])
      redirect_to fraud_score_path
  end
  
  def add_hosting_plan
      @admin_plan = AdminPlan.new
      phase = params[:phase] if params[:phase]
      
      case phase
      when '1'
      when '2'
         render :phase2
      when '3' 
         render :phase3
      when '4'
         render :phase4
      when '5'
         render :phase5
      when '6'
         render :phase6            
      when '7'
         render :phase7
      when '8'
      else
      end  
  end
  
  
  
  
end

