class AdminClientsController < ApplicationController
  layout 'admin_backend'   
  before_filter :admin_current_user
  
  
  def view_all_clients
    
  end
  
  def add_new_client
        @user_title = {"Mr."=>"Mr.","Mrs."=>"Mrs.","Ms."=>"Ms."}
    @user = User.new      
  end
end
