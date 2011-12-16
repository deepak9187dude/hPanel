class AdminTicketsController < ApplicationController 
  layout 'admin_backend'   
  before_filter :admin_current_user
  
  def support_tickets
#    Delete Tickets
    if params[:chkdel]
      del = params[:chkdel]
      Ticket.destroy(del)      
    end
    if !params[:show]
      @tickets = @support_all
      if params[:limit]
# render :text =>'hi'
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
# @tickets = Ticket.where("#{params[:cmbsearch]} = ? AND category = ?",params[:txtsearch].to_s,"support").find(:all, :order => "id desc", :limit => params[:limit])
         if params[:cmbsearch].to_s.downcase == "lastactivity"
           
         else
          @tickets = Ticket.find(:all,:conditions=>["#{params[:cmbsearch].to_s.downcase} like ? AND category = 'support'", params[:txtsearch].to_s.strip.downcase],:limit=>params[:limit])
         end
      end
    end
    render "tickets"
# render :text => params.to_json
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
# @tickets = Ticket.where("#{params[:cmbsearch]} = ? AND category = ?",params[:txtsearch].to_s,"support").find(:all, :order => "id desc", :limit => params[:limit])
         if params[:cmbsearch].to_s.downcase == "lastactivity"
           
         else
          @tickets = Ticket.find(:all,:conditions=>["#{params[:cmbsearch].to_s.downcase} like ? AND category = 'billing'", params[:txtsearch].to_s.strip.downcase],:limit=>params[:limit])
         end
      end
    end
    render "tickets"
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
      redirect_to admin_all_support_tickets_path
    elsif ticket.category =="Billing"
      redirect_to admin_all_billing_tickets_path
    else
    end
  end
  
  def create_reply
    ticket_reply = TicketDetail.new(params[:ticket_detail])
    ticket_reply.replier_id = @current_user.id
    ticket_reply.ticket_id=params[:id]
# ticket_reply.ticket.status = ticket_reply.status
    ticket = Ticket.find(ticket_reply.ticket_id)
    ticket.status = ticket_reply.status
    ticket.save
    ticket_reply.save
    redirect_to admin_ticket_details_path(params[:id])
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
end
