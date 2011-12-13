class AdminController < ApplicationController  
  layout 'admin_backend'   
  before_filter :current_user, :except=>[:login,:forgot_password]
  def current_user
    if session[:user_id]
      @current_user = User.find(session[:user_id])
      @support_all = Ticket.support_tickets(@current_user)
      @support_open = Ticket.support_opened(@current_user)
      @support_hold = Ticket.support_hold(@current_user)
      @support_closed = Ticket.support_closed(@current_user)
      @support_progress = Ticket.support_progress(@current_user)

      @billing_all = Ticket.billing_tickets(@current_user)
      @billing_open = Ticket.billing_opened(@current_user)
      @billing_hold = Ticket.billing_hold(@current_user)
      @billing_closed = Ticket.billing_closed(@current_user)
      @billing_progress = Ticket.billing_progress(@current_user)
      @ticket_priority = {'-Select Priority-' => '','Low' => 'Low', 'Medium' => 'Medium','High'=>'High','Urgent'=>'Urgent','Emergency'=>'Emergency','Critical'=>'Critical'}
      @ticket_category = {'-Select Category-' => '', 'Support' => 'Support','Billing'=>'Billing'}
      @cc_type = {'Visa' => 'Visa', 'MasterCard' => 'MasterCard','Discover'=>'Discover','American Express'=>'American Express'}
    else
      redirect_to reseller_login_path ,:message=>'Please log in'
    end
  end
  
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
  
end
