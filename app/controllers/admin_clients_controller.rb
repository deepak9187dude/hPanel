class AdminClientsController < ApplicationController
  layout 'admin_backend'   
  before_filter :admin_current_user
  
  
  def view_all_clients
    @clients = User.find(:all)
  end
  
  
  def add_new_client
    @client_title = {"Mr."=>"Mr.","Mrs."=>"Mrs.","Ms."=>"Ms."}
    @client = User.new      
  end
  
  def client_edit
    @client_title = {"Mr."=>"Mr.","Mrs."=>"Mrs.","Ms."=>"Ms."}
    @client = User.find(params[:id])
  end
  
  def create
    if params[:user]
      @user = User.new(params[:user])
      @user.save!
    end
    redirect_to(admin_all_clients_path)
  end
end
