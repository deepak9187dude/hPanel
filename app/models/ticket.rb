class Ticket < ActiveRecord::Base
  belongs_to :user
  has_many :ticket_details, :dependent => :destroy
    
  def ticket_type
    self.category.downcase == "support"?"Support Ticket":"Billing Ticket"
  end
#support tickets
  def self.support_tickets(user)
    where("category=? AND user_id = ?","support",user)
  end  
  def self.admin_support_tickets
    where("category=?","support")
  end
    
  def self.support_opened(user)
    where("status = ? AND category=? AND user_id = ?","open","support",user)
  end
  def self.admin_support_opened
    where("status = ? AND category=?","open","support")
  end
  
  def self.support_hold(user)
    where("status = ? AND category=? AND user_id = ?","hold","support",user)
  end
  def self.admin_support_hold
    where("status = ? AND category=?","hold","support")
  end
  
  def self.support_closed(user)
    where("status = ? AND category=? AND user_id = ?","close","support",user)
  end
  def self.admin_support_closed
    where("status = ? AND category=?","close","support")
  end
  
  def self.support_progress(user)
    where("status = ? AND category=? AND user_id = ?","progress","support",user)
  end
  def self.admin_support_progress
    where("status = ? AND category=?","progress","support")
  end
  
#billing tickets
  def self.billing_tickets(user)
    where("category=? AND user_id = ?","billing",user)
  end
  def self.admin_billing_tickets
    where("category=?","billing")
  end
  
  def self.billing_opened(user)
    where("status = ? AND category=? AND user_id = ?","open","billing",user)
  end
  def self.admin_billing_opened
    where("status = ? AND category=?","open","billing")
  end
  
  def self.billing_hold(user)
    where("status = ? AND category=? AND user_id = ?","hold","billing",user)
  end
  def self.admin_billing_hold
    where("status = ? AND category=?","hold","billing")
  end
  
  def self.billing_closed(user)
    where("status = ? AND category=? AND user_id = ?","close","billing",user)
  end
  def self.admin_billing_closed
    where("status = ? AND category=?","close","billing")
  end
  
  def self.billing_progress(user)
    where("status = ? AND category=? AND user_id = ?","progress","billing",user)
  end
  def self.admin_billing_progress
    where("status = ? AND category=?","progress","billing")
  end
  
  def status_image
    if self.status.downcase.strip == "open"
      @icon = 'icon_inprocess.png'
    elsif self.status.downcase.strip == "hold"
      @icon = 'offline.png'
    elsif self.status.downcase.strip == "closed"
      @icon = 'online.png'
    else
      @icon = 'offline.png'      
    end
  end  
end
