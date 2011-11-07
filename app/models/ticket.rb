class Ticket < ActiveRecord::Base
  belongs_to :user
  has_many :ticket_details
    
  
  def self.support_tickets(user)
    where("status = ? AND user_id = ?","open",user)
  end
  def self.support_opened(user)
    where("status = ? AND user_id = ?","open",user)
  end
  def self.support_hold(user)
    where("status = ? AND user_id = ?","hold",user)
  end
  def self.support_closed(user)
    where("status = ? AND user_id = ?","closed",user)
  end
  def self.support_progress(user)
    where("status = ? AND user_id = ?","progress",user)
  end
end
