class SessionsController < ApplicationController
  def create
    if user = User.authenticate(params[:username], params[:password])
      session[:user_id] = user.id
      session[:user_type] = user.account_type
#      render :text => "logged in"
      if user.account_type.strip.downcase == "admin"
        redirect_to reseller_index_path, :notice => "Logged in successfully"
      elsif user.account_type.strip.downcase == "superadmin"
        redirect_to admin_path, :notice => "Logged in successfully"        
      else
        redirect_to root_path, :notice => "Logged in successfully"
      end
    else
      flash.now[:alert] = "Invalid login/password combination"
      redirect_to reseller_login_path,:notice => "Incorrect Username or password"
#      render 'new'
#       render :text => "not a valid user"
    end
  end  
  def destroy
    reset_session
    redirect_to reseller_login_path, :notice => "You successfully logged out"
  end
end
