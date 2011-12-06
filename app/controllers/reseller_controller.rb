class ResellerController < ApplicationController
  layout 'reseller_backend'  
  require 'Bluepay'
  include ActiveMerchant::Billing
  
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
    if params[:old_password]==@user.password
      if params[:resetpassword] && params[:password]==params[:re_password]
        @user.password = params[:password]
        @user.save
        flash[:info_msg] = "password updated successfully"
        redirect_to reseller_update_password_path
      else
        flash[:error_msg] = "password no not match"
        redirect_to reseller_update_password_path
      end
    else
      flash[:error_msg] = "Incorrect old password"
      redirect_to reseller_update_password_path
    end        
  end
  
  def vm_change_password
    @vm = Vm.find(params[:id])
  end
#  
#  
  def vm_new_password
    @vm = Vm.find(params[:id])
    if params[:old_password] == @vm.password
      if params[:resetpassword] && params[:password]==params[:re_password]
        @vm.password = params[:password]
        @vm.save
        flash[:info_msg] = "password updated successfully"
        redirect_to vm_change_password_path
      else
        flash[:error_msg] = "password no not match"
        redirect_to vm_change_password_path
      end
    else
      flash[:error_msg] = "Incorrect old password"
      redirect_to vm_change_password_path
    end        
  end

  def vm_details
    @vm = Vm.find(params[:id])
  end
  
  def vm_processes
    @vm = Vm.find(params[:id])
    @ps = `ps -eo pid,stat,pmem,user,command h`
    @ps = @ps.split("\n")
    
#    render:text=>@ps.size
  end
  
  def vm_services
    @vm = Vm.find(params[:id])
    @services = `sysv-rc-conf --list`
    @services = @services.split("\n")
  end
  
  def vm_ssh
    @vm = Vm.find(params[:id])
  end
  def vm_delete
    @vm = Vm.find(params[:id])
    render :text=>'<br><span class="bolderror">VM Delete has been scheduled successfully.</span>'
  end
  
  def vm_boot
    @vm = Vm.find(params[:id])
    render :text=>'<br><span class="bolderror">VM Boot has been scheduled successfully.</span>'
  end
  
  def vm_shutdown
    @vm = Vm.find(params[:id])
    render :text=>'<br><span class="bolderror">VM Shutdown has been scheduled successfully.</span>'
  end
  
  def vm_reboot
    @vm = Vm.find(params[:id])
    render :text=>'<br><span class="bolderror">VM Reboot has been scheduled successfully.</span>'
  end
  
  def plan_summary
  end
  
  def view_all_vm
    @vms = @current_user.vms
    
    if params[:limit]
      @vms = @current_user.vms.find(:all, :order => "id desc", :limit => params[:limit])
      @selection = params[:limit]
    end
  end
  def del_vm
    
  end
  
  def billing_termination
    
  end
  def payment_methods
    
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
  
  def payment_selection
      plan = Plan.find(params[:plan_id]) if params[:plan_id]
      if plan
          @plan_title = plan.title
          @no_of_vps  = plan.vps
          session[:plan_id] = params[:plan_id] if params[:plan_id]
          session[:plan_type] = params[:plantype].to_s  if params[:plantype]
      end
      if params[:plantype] and plan
          billing_plan = plan.plan_billing_rate
          @plan_billing_rate = billing_plan.current_plan_price(params[:plantype].to_s) 
          @plan_period = period(params[:plantype].to_s)
      end   
  end
 
  def period(p)
      p = p.downcase
      if p == "monthly"
         p = "month"
      elsif p == "quaterly"
         p = "3 months"
      elsif p == "yearly"
         p= "year"
      elsif p == "semi"
         p = "6 months" 
      end
      
      return p
  end
 
  def upgrade_plan
      plan = Plan.find(session[:plan_id]) if session[:plan_id]
      if plan
          @plan_title = plan.title
          @no_of_vps  = plan.vps
      end
      if  session[:plan_type] and plan
          billing_plan = plan.plan_billing_rate
          @plan_billing_rate = billing_plan.current_plan_price(session[:plan_type].to_s) 
          @plan_period = period(session[:plan_type].to_s)
          session[:amount_to_charge] = @plan_billing_rate
      end 
      @cc_data = Ccdata.new
  end 
  ############################################################################
  ###                       payment methods                              #####
  ############################################################################
  def gateway_payment 
      plan = Plan.find(session[:plan_id]) if session[:plan_id]
      if  session[:plan_type] and plan
          billing_plan = plan.plan_billing_rate
          plan_billing_rate = billing_plan.current_plan_price(session[:plan_type].to_s) 
      end
      if request.post?
         if params[:ccdata]
            @ccdata = Ccdata.new(params[:ccdata])            
            if @ccdata.isUserAccAddress == 1 then
               @ccdata.address = @current_user.address
               @ccdata.address2 = @current_user.address2
               @ccdata.city = @current_user.city
               @ccdata.state = @current_user.state
               @ccdata.state_other = @current_user.state_other
               @ccdata.country = @current_user.country
               @ccdata.postal_code = @current_user.postal_code
               @ccdata.phccode = @current_user.phccode
               @ccdata.phacode = @user_current.phacode
               @ccdata.phnumber = @current_user.phnumber
            end
            @ccdata.save
            invoice = InvoiceDetail.new
            invoice.user_id = @current_user.id
            subscription = plan.subscriptions.new
            subscription.name = plan.title
            subscription.user_id = @current_user.id
            invoice.plan_id = plan.id
            invoice.cc_id = @ccdata.id
            invoice.transaction_type = 'Sale'     
            invoice.payment_date = Time.now          
            invoice.amount_credited = plan_billing_rate            
            #payment using bluepay payment gateway
            if params[:type].to_s.downcase == 'bluepay'
                bpApi = Bluepay.new(BP_ACCOUNT_ID.to_s, BP_SECRET_KEY.to_s)
                bpApi.customer_data(@ccdata.first_name.to_s,@ccdata.last_name.to_s,@ccdata.address.to_s,@ccdata.address2.to_s,@ccdata.state.to_s,@ccdata.postal_code.to_s)
                exp_date = @ccdata.exp_month.to_s + @ccdata.exp_year.to_s
                bpApi.use_card(@ccdata.card_num.to_s, exp_date , @ccdata.cvv.to_s)
                #bpApi.easy_sale(plan_billing_rate)
                bpApi.easy_sale("1.00")
                bpApi.process()                
                if bpApi.get_status() == '1' then
                   msg = bpApi.get_message() + bpApi.get_trans_id()
                   invoice.cc_trans_id = bpApi.get_trans_id().to_s
                   invoice.gateway_pay_status = "Approved"
                   invoice.gateway_trans_type = 'Sale'
                   invoice.gateway_trans_time = Time.now
                   invoice.pay_success_date = Time.now
                   invoice.pay_mode = 1 #'Bluepay'
                   invoice.payment_status = 'Approved'
                   subscription.status = "Approved"
#                   subscription.end_date
#                  subscription.billing_period = 
#                  subscription.next_billing_period =
                   msg = "Payment Successfull" 
                   flash[:notice] = msg
                else
                   msg = bpApi.get_message()
                   invoice.gateway_pay_status = "Pending"
                   subscription.status = "failed"
                   flash[:error] = msg
                end
            elsif params[:type].to_s.downcase == 'paypal'
                redirect_to paypal_checkout_path(plan_billing_rate.to_i)
                return
            end
            subscription.save
            invoice.subscription_id=subscription.id
            invoice.save
         end
      end
      redirect_to reseller_index_path ,:message=>msg
  end
  
  
  def checkout
#    render :text => params.to_json
#    return
    if params[:amount] then
       amount = params[:amount]
       session[:amount] = amount
        setup_response = gateway.setup_purchase(amount.to_i,
        :ip => request.remote_ip,
        :return_url => url_for(:action => 'confirm', :only_path => false),
        :cancel_return_url => url_for(:action => 'index', :only_path => false)
        ) 
    end
      redirect_to gateway.redirect_url_for(setup_response.token)
  end
  
  def confirm
      redirect_to :action => 'index' unless params[:token]
      details_response = gateway.details_for(params[:token])
      if !details_response.success?
          @message = details_response.message
          render :action => 'error'
          return
      end
      @address = details_response.address
      session[:address] = @address
      #     render :text=> details_response.to_json
  end

   def complete
       plan = Plan.find(session[:plan_id]) if session[:plan_id]
        if  session[:plan_type] and plan
            billing_plan = plan.plan_billing_rate
            plan_billing_rate = billing_plan.current_plan_price(session[:plan_type].to_s) 
        end
        
        @ccdata = Ccdata.new
        @address = session[:address] if session[:address]
        if @addressthen
           @ccdata.address = @address.address1
           @ccdata.address2 = @address.address2 
           @ccdata.city = @address.city
           @ccdata.state = @address.state
           @ccdata.country = @address.country
           @ccdata.postal_code = @address.zip
           @ccdata.save
        end
         purchase = gateway.purchase(session[:amount].to_i,
           :ip       => request.remote_ip,
           :payer_id => params[:payer_id],
           :token    => params[:token]
         ) if session[:amount]
     
         if !purchase.success?
           @message = purchase.message
           render :action => 'error'
           return
         end
    
        invoice = InvoiceDetail.new
        invoice.user_id = @current_user.id
        subscription = plan.subscriptions.new
        subscription.name = plan.title
        subscription.user_id = @current_user.id
        invoice.plan_id = plan.id
        invoice.cc_id = @ccdata.id
        invoice.transaction_type = 'Sale'     
        invoice.payment_date = Time.now          
        invoice.amount_credited = plan_billing_rate   
      #  invoice.cc_trans_id = bpApi.get_trans_id().to_s
        invoice.gateway_pay_status = "Approved"
        invoice.gateway_trans_type = 'Sale'
        invoice.gateway_trans_time = Time.now
        invoice.pay_success_date = Time.now
        invoice.pay_mode = 2 #'paypal'
        invoice.payment_status = 'Approved'
        subscription.status = "Approved"
        invoice.save
        subscription.save
   end

 private
   def gateway
     @gateway ||= PaypalExpressGateway.new(
       :login => PP_LOGIN,
       :password => PP_PASSWORD,
       :signature => PP_SIGNATURE
     )
   end
  ######################   end payment methods #################################
 public
  
  def licence_code

  end
  
  def download

  end
  
  def ssh_demo
    
  end
  
  def billing_history
      @billings = @current_user.invoice_details
#    params[:left]=1
#    render :text=>params.to_json
      
    if params[:limit]
      @billings = @current_user.invoice_details.find(:all, :order => "id desc", :limit => params[:limit])
      @selection = params[:limit]
    end
  end
  
  def order_details
    @order_details = InvoiceDetail.find(params[:id])
    @total = @order_details.amount_credited
  end
  def order_history
    @order_history = InvoiceDetail.find_all_by_id(params[:id])
  end
  
  def support_tickets
    if !params[:show]
      @tickets = @support_all
      if params[:limit]
#        render :text =>'hi'
      end
    elsif(params[:show]=="open")
      @tickets = @support_open
    elsif(params[:show]=="hold")
      @tickets = @support_hold
    elsif(params[:show]=="closed")
      @tickets = @support_closed
    elsif(params[:show]=="progress")
      @tickets = @support_progress
    end
    if params[:limit]
      @selection = params[:limit]
      @tickets = @tickets.find(:all,:limit=>params[:limit])
      if params[:txtsearch] and params[:txtsearch].strip !=""
#        @tickets = Ticket.where("#{params[:cmbsearch]} = ? AND category = ?",params[:txtsearch].to_s,"support").find(:all, :order => "id desc", :limit => params[:limit])
         if params[:cmbsearch].to_s.downcase == "lastactivity"
           
         else
          @tickets = Ticket.find(:all,:conditions=>["#{params[:cmbsearch].to_s.downcase} like ? AND  category = 'support'", params[:txtsearch].to_s.strip.downcase],:limit=>params[:limit])
         end
      end
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
    if params[:limit]
      @selection = params[:limit]
      @tickets = @tickets.find(:all,:limit=>params[:limit])
      if params[:txtsearch] and params[:txtsearch].strip !=""
#        @tickets = Ticket.where("#{params[:cmbsearch]} = ? AND category = ?",params[:txtsearch].to_s,"support").find(:all, :order => "id desc", :limit => params[:limit])
         if params[:cmbsearch].to_s.downcase == "lastactivity"
           
         else
          @tickets = Ticket.find(:all,:conditions=>["#{params[:cmbsearch].to_s.downcase} like ? AND  category = 'billing'", params[:txtsearch].to_s.strip.downcase],:limit=>params[:limit])
         end
      end
    end
    render "tickets"
  end

  def billing_subscriptions
    @subscriptions = @current_user.subscriptions
    
    if params[:limit]
      @subscriptions = @current_user.subscriptions.find(:all, :order => "id desc", :limit => params[:limit])
      @selection = params[:limit]
    end
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
    ticket_details.save
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
