class FrontController < ApplicationController
  layout "frontend"
  @show_slider = false
  def index
    @show_slider = true
    @title = ""
    
  end
  def pricing
    @title = "Pricing"
    @plans = Plan.all
  end
  def signinh
    @user = User.new
  end
end
