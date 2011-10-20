class UsersController < ApplicationController
  def index 
    @users = User.find(:all, :conditions => ["id != ?", 1])
  end

  def create #create a new
    @user = User.create(params[:user])
    redirect_to clients_path
  end

  def show #display a specific
  end

  def update #update a specific
    if params[:user]
      @user = User.find(params[:id])
      @user.update_attributes(params[:user])
      redirect_to clients_path
    end
  end

  def new #return an HTML form for creating a new
    @user = User.new
  end

  def destroy #delete a specific
    @user = User.find(params[:id])
#    @user.destroy
    redirect_to clients_path
  end

  def edit #return an HTML form for editing
    @user = User.find(params[:id])
  end
end
