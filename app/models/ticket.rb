class Ticket < ActiveRecord::Base
  belongs_to :user
  has_many :ticket_details
    
#support tickets
  def self.support_tickets(user)
    where("category=? AND user_id = ?","support",user)
  end
  
  def self.support_opened(user)
    where("status = ? AND category=? AND user_id = ?","open","support",user)
  end
  def self.support_hold(user)
    where("status = ? AND category=? AND user_id = ?","hold","support",user)
  end
  def self.support_closed(user)
    where("status = ? AND category=? AND user_id = ?","closed","support",user)
  end
  def self.support_progress(user)
    where("status = ? AND category=? AND user_id = ?","progress","support",user)
  end
  
#billing tickets
  def self.billing_tickets(user)
    where("category=? AND user_id = ?","billing",user)
  end
  def self.billing_opened(user)
    where("status = ? AND category=? AND user_id = ?","open","billing",user)
  end
  def self.billing_hold(user)
    where("status = ? AND category=? AND user_id = ?","hold","billing",user)
  end
  def self.billing_closed(user)
    where("status = ? AND category=? AND user_id = ?","closed","billing",user)
  end
  def self.billing_progress(user)
    where("status = ? AND category=? AND user_id = ?","progress","billing",user)
  end
end
