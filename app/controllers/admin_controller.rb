class AdminController < ApplicationController  
  layout 'admin_backend'   
  before_filter :admin_current_user
  
  def index
    @clients = User.all
  end

  def admin_subscriptions    
    @sub_type = params[:type]
    case @sub_type
    when "all"
      @subscriptions = ""
      @sub_navigation = "Subscriptions"
    when "onhold"
      @subscriptions = ""
      @sub_navigation = "Subscriptions On Hold "
    when "expired"
      @subscriptions = ""
      @sub_navigation = "Expired"
    when "termination"
      @subscriptions = ""
      @sub_navigation = "Terminated"
    when "failed"
      @subscriptions = ""
      @sub_navigation = "Failed"
    else
      @subscriptions = ""
      @sub_navigation = "Failed"
    end
    render 'admin_subscriptions/all_subscriptions'
  end
  
  def grace_period_settings
    
  end
  
  def termination_request
    
  end
  
  def resolver_management
    
  end
  def reset_password
    
  end
  
  def change_password
    @user = User.find(params[:id])
    if params[:old_password]==@user.password
      if params[:resetpwd] && params[:password]==params[:re_password]
        @user.password = params[:password]
        @user.save
        flash[:info_msg] = "password updated successfully"
        redirect_to admin_reset_password_path
      else
        flash[:error_msg] = "password do not match"
        redirect_to admin_reset_password_path
      end
    else
      flash[:error_msg] = "Incorrect old password"
      redirect_to admin_reset_password_path
    end
  end
end
