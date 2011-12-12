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
  
  def all_subscriptions
    render "admin_subscriptions/all_subscriptions"
  end
  
  def subscriptions_on_hold
    render "admin_subscriptions/subscriptions_on_hold"
  end
  
  def subscriptions_expired
    render "admin_subscriptions/subscriptions_expired"
  end
  
  def subscriptions_termination_queue
    render "admin_subscriptions/subscriptions_termination_queue"
  end
  
  def subscriptions_failed
    render "admin_subscriptions/subscriptions_failed"
  end
  
end
