class ResellerController < ApplicationController
  layout 'reseller_backend'
  def index
    @user = User.find(session[:user_id])
#    render :text=>session.to_json
  end
  def login
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
    
  end
  
end
