class AdminBillingsController < ApplicationController
  layout 'admin_backend'   
  before_filter :admin_current_user
  def hosting_plans    
  end
  
  def receivables
    @receivable_type = params[:type]
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
    else
      @receivables = ""
      @receivable_navigation = ""
    end
  end
end
