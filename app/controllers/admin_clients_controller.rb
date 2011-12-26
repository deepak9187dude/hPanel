class AdminClientsController < ApplicationController
  layout 'admin_backend'   
  before_filter :admin_current_user
  
  
  def view_all_clients
#    Delete Users
    if params[:chkdel]
      del = params[:chkdel]
      User.destroy(del)      
    end
    @users = User.active
#    search
    if params[:limit]
      @selection = params[:limit]
      @users = @users.find(:all,:limit=>params[:limit])
      if params[:txtsearch] and params[:txtsearch].strip !=""
# @tickets = Ticket.where("#{params[:cmbsearch]} = ? AND category = ?",params[:txtsearch].to_s,"support").find(:all, :order => "id desc", :limit => params[:limit])
         if params[:cmbsearch].to_s.downcase == "lastactivity"
           
         else
          @users = User.find(:all,:conditions=>["#{params[:cmbsearch].to_s.downcase} like ?", "%"+params[:txtsearch].to_s.strip.downcase+"%"],:limit=>params[:limit])
         end
      end
    end    
  end
  
  def client_manager
    @clients_active = User.active
    @clients = User.all
  end
  
  
  def add_new_client
    @user_title = {"Mr."=>"Mr.","Mrs."=>"Mrs.","Ms."=>"Ms."}
    @user = User.new
    @url = admin_create_client_path
  end
  
  def client_edit
    @user_title = {"Mr."=>"Mr.","Mrs."=>"Mrs.","Ms."=>"Ms."}
    @user = User.find(params[:id])
   @url = admin_update_client_path
  end
  
  def general_settings
    @user = User.find(params[:id])
  end
  
  def client_vms
    
  end
  def containers
    
  end
  def billing_history
    
  end
  def create
    if params[:user]
      @user = User.new(params[:user])
      @user.save!
    end
    redirect_to(admin_all_clients_path)
  end
  
  def client_update
    if params[:user]
      @user = User.find(params[:id])
      @user.update_attributes(params[:user])
    end
    redirect_to(admin_all_clients_path)   
  end
  
  def client_delete
    client = User.find(params[:id])
    client.destroy
    redirect_to(admin_all_clients_path) 
  end
end
