class AdminController < ApplicationController  
  layout 'admin_backend'   
  before_filter :admin_current_user
  
  def index
    
  end
  
  def view_all_clients
    render "admin_clients/view_all_clients"
  end
  
  def add_new_client
    render "admin_clients/add_new_client"
  end
  
  def admin_subscriptions    
    @sub_type = params[:type]
    case @sub_type
    when "all"
      @subscription = ""
      @sub_navigation = "Subscriptions"
    when "onhold"
      @subscription = ""
      @sub_navigation = "Subscriptions On Hold "
    when "expired"
      @subscription = ""
      @sub_navigation = "Expired"
    when "termination"
      @subscription = ""
      @sub_navigation = "Terminated"
    when "failed"
      @subscription = ""
      @sub_navigation = "Failed"
    else
      @subscription = ""
      @sub_navigation = "Failed"
    end
    render 'admin_subscriptions/all_subscriptions'
  end
  
  def grace_period_settings
    
  end
  
  def termination_request
    
  end
  
  def resolver_management
    
  end
end
