class AdminBillingsController < ApplicationController
  layout 'admin_backend'   
  before_filter :admin_current_user
  def hosting_plans    
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
    
  end
  
  def configure_gateway
      @gateway_configuration = Gateway.find(params[:id]) if params[:id]
  end
  
  def gateway_update
      @gateway_configuration = Gateway.find(params[:id]) if params[:id]
      @gateway_configuration.update_attributes(params[:gateway_configuration]) 
      redirect_to gateway_settings_path
  end
  
end

