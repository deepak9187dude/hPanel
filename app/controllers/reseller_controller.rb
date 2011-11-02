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
    
  end
  def licence_code
    
  end
  def download
    
  end
  def billing_history
#    params[:left]=1
#    render :text=>params.to_json
  end
  
end
