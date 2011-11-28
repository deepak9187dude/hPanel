class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :plan
  has_one    :invoice_detail
  after_create :set_name  
  def set_name
    self.name = self.id.to_s+" " + self.plan.title
    self.save
  end
  def status_image
    if self.status.downcase.strip == "failed"
      @icon = 'offline.png'
    elsif self.status.downcase.strip == "approved"
      @icon = 'online.png'
    else
      @icon = 'offline.png'      
    end
  end  
end
