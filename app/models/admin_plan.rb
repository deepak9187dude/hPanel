class AdminPlan < ActiveRecord::Base
  belongs_to   :PlanCategory
 #  has_one      :PlanCategory
  
  def sell_option
    if self.plan_sell_option == false
      @icon = 'tick.gif'      
    else
      @icon = 'minus.gif'      
    end
  end
    
  def sell_status
  
    if self.plan_sell_option == true
      @icon = 'online.png'
    else
      @icon = 'offline.png'      
    end
  end

  def sell_status_msg
  
    if self.plan_sell_option == true
      @icon = 'Selling'
    else
      @icon = 'Stopped'      
    end
    
  end
  
  def status
  
    if self.isAvailable == true
      @icon = 'online.png'
    else
      @icon = 'offline.png'      
    end
  end

  def status_msg
  
    if self.isAvailable == true
      @icon = 'Active'
    else
      @icon = 'In-Active'      
    end
    
  end


end
