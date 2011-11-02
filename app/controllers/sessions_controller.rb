class SessionsController < ApplicationController
  def create
    if user = User.authenticate(params[:username], params[:password])
      session[:user_id] = user.id
      session[:user_type] = user.account_type
#      render :text => "logged in"
      if user.account_type.downcase == "admin"
        redirect_to reseller_index_path, :notice => "Logged in successfully"
      else
        redirect_to root_path, :notice => "Logged in successfully"
      end
    else
      flash.now[:alert] = "Invalid login/password combination" 
      render 'new'
#       render :text => "not a valid user"
    end
  end  
  def destroy
    reset_session
    redirect_to root_path, :notice => "You successfully logged out"
  end
end
