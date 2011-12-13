class AdminBillingsController < ApplicationController
  layout 'admin_backend'   
  before_filter :admin_current_user
  def hosting_plans    
  end
end
