class AdminClientsController < ApplicationController
  layout 'admin_backend'   
  before_filter :admin_current_user
  
  
  def view_all_clients
    @users = User.find(:all)
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
  
  def create
    if params[:user]
      @user = User.new(params[:user])
      @user.save!
    end
    redirect_to(admin_all_clients_path)
  end
  
  def client_update
    if params[:client]
      @user = User.find(params[:id])
      @user.update_attributes(params[:user])
    end
    redirect_to(admin_all_clients_path)   
  end
end
