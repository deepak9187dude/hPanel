class UsersController < ApplicationController
  layout 'backend'
  def index 
    @users = User.find(:all, :conditions => ["id != ?", 1])
  end

  def create #create a new
    if user = isuserexist(params[:user][:email])      
    else
      user = User.create(params[:user])
    end
    if params[:register_from_front]
      if session[:plan_id] && session[:plan_type]
        plan = Plan.find(session[:plan_id])
        plan_type = session[:plan_type]
        user_plan = UserPlan.new
        user_plan.plan_id = plan.id
        user_plan.plan_current_status = 0
        user_plan.user_id = user.id
        user_plan.save
        subscription = Subscription.new
        subscription.status = 'failed'
        subscription.plan_id = plan.id
        subscription.end_date = Time.now
        subscription.user_id = user.id
        subscription.save
#        subscription.name = subscription.id.to_s+""+subscription.plan.title
#        subscription.save
      end
      redirect_to "/payoptionsh"
    else
    	redirect_to clients_path
    end
  end

  def show #display a specific
    @user = User.find(params[:id])
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
  
  def login
    
  end
  
  def isuserexist(email)
    user = User.find_by_email(email)    
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
