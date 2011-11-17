class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :plan
  after_create :set_name
  
  def set_name
    self.name = self.id.to_s+" " + self.plan.title
    self.save
  end
  
end
