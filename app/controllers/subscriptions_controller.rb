class SubscriptionsController < ApplicationController
  layout "backend"
  def index 
#    @subscriptions = subscription.find(:all, :conditions => ["id != ?", 1]
    #@subscriptions = Subscription.find(:all)
    @subscriptions = UserPlan.find(:all) 
  end
  def search
    
  end
end
