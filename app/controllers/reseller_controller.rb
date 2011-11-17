class ResellerController < ApplicationController
  layout 'reseller_backend'
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
    else
      redirect_to reseller_login_path ,:message=>'Please log in'
    end
  end
  def index
    @user = User.find(session[:user_id])
#    render :text=>session.to_json
  end
  def login
    render :layout => 'reseller_layout'
  end

  def forgot_password
    if params[:email_1_2]
      if @current_user = User.find_by_email(params[:email_1_2])
        Mails.forgot_password(@current_user).deliver
        redirect_to reseller_login_path
      else
        redirect_to root_path
      end
      return
    end
    render :layout => 'reseller_layout'
  end

  def edit
    @user = User.find(session[:user_id])
    render '_reseller_edit'
  end

  def reseller_update
    if params[:user]
      @user = User.find(session[:user_id])
      @user.update_attributes(params[:user])
    end
    redirect_to(reseller_index_path)
  end

  def change_password
#    if params[:password]
  end
  def new_password
    @user = User.find(session[:user_id])
    if params[:resetpassword] && params[:password]==params[:re_password]
      @user.password = params[:password]
      @user.save
      flash[:info_msg] = "password updated successfully"
      redirect_to reseller_update_password_path
    else
      flash[:error_msg] = "password no not match"
      redirect_to reseller_update_password_path
    end
  end

  def plan_summary
  end

  def licence_upgrade
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
        @plan_rows << row
      end
    end
  end
  
  
  def licence_code

  end
  def download

  end
  def billing_history
#    params[:left]=1
#    render :text=>params.to_json
  end

  def support_tickets
    if !params[:show]
      @tickets = @support_all
    elsif(params[:show]=="open")
      @tickets = @support_open
    elsif(params[:show]=="hold")
      @tickets = @support_hold
    elsif(params[:show]=="closed")
      @tickets = @support_closed
    elsif(params[:show]=="progress")
      @tickets = @support_progress
    end
    render "tickets"
#    render :text => params.to_json
  end

  def billing_tickets
    if !params[:show]
      @tickets = @billing_all
    elsif(params[:show]=="open")
      @tickets = @billing_open
    elsif(params[:show]=="hold")
      @tickets = @billing_hold
    elsif(params[:show]=="closed")
      @tickets = @billing_closed
    elsif(params[:show]=="progress")
      @tickets = @billing_progress
    end
    render "tickets"
  end

  def billing_subscriptions
    @subscriptions = @current_user.subscriptions
  end

  def new_ticket
    @ticket = Ticket.new
  end

  def create_ticket
    ticket = Ticket.new(params[:ticket])
    if ticket.category == ""
      render "new_ticket"
      return
    end

    ticket.user_id=@current_user.id
    ticket.random=ActiveSupport::SecureRandom.base64(10)#need to be changed later
    ticket.save
    ticket_details=ticket.ticket_details.new
    ticket_details.comments = ticket.comments
    ticket_details.replier_id = @current_user.id
    ticket_ddef licence_upgrade
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
        @plan_rows << row
      end
    end
  endetails.save
    if ticket.category =="Support"
      redirect_to reseller_all_support_tickets_path
    elsif ticket.category =="Billing"
      redirect_to reseller_all_billing_tickets_path
    else
    end
  end

  def create_reply
    ticket_reply = TicketDetail.new(params[:ticket_detail])
    ticket_reply.replier_id = @current_user.id
    ticket_reply.ticket_id=params[:id]
#    ticket_reply.ticket.status = ticket_reply.status
    ticket = Ticket.find(ticket_reply.ticket_id)
    ticket.status = ticket_reply.status
    ticket.save
    ticket_reply.save
    redirect_to reseller_ticket_details_path(params[:id])
  end

  def ticket_details
    if params[:page] == 'general'
      @ticket = Ticket.find(params[:id])
      render '_ticket_general_details'

    elsif params[:page] == 'reply'
      @ticket_status = {'-Select Status-' => '', 'Open' => 'Open','On Hold'=>'hold','Closed'=>'close','In Progress'=>'progress'}
      @ticket = Ticket.find(params[:id])
      @ticket_detail = @ticket.ticket_details.new
      render '_ticket_post_reply'


    elsif params[:page] == 'history'
      @ticket = Ticket.find(params[:id])
      @ticket_history = @ticket.ticket_details
      render '_ticket_history'
    end
  end
  
  def subscription_details
    @subscription = Subscription.find(params[:id])
  end
end
