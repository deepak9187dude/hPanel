class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def admin_current_user
    if session[:user_id]
      @current_user = User.find(session[:user_id])
      @support_all = Ticket.admin_support_tickets
      @support_open = Ticket.admin_support_opened
      @support_hold = Ticket.admin_support_hold
      @support_closed = Ticket.admin_support_closed
      @support_progress = Ticket.admin_support_progress

      @billing_all = Ticket.admin_billing_tickets
      @billing_open = Ticket.admin_billing_opened
      @billing_hold = Ticket.admin_billing_hold
      @billing_closed = Ticket.admin_billing_closed
      @billing_progress = Ticket.admin_billing_progress
      @ticket_priority = {'-Select Priority-' => '','Low' => 'Low', 'Medium' => 'Medium','High'=>'High','Urgent'=>'Urgent','Emergency'=>'Emergency','Critical'=>'Critical'}
      @ticket_category = {'-Select Category-' => '', 'Support' => 'Support','Billing'=>'Billing'}
      @cc_type = {'Visa' => 'Visa', 'MasterCard' => 'MasterCard','Discover'=>'Discover','American Express'=>'American Express'}
    else
      redirect_to reseller_login_path ,:message=>'Please log in'
    end
  end
end
