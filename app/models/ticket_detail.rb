class TicketDetail < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :user,:foreign_key=>"replier_id"
  
  
  def status_image
    if self.status.downcase.strip == "open"
      @icon = 'icon_inprocess.png'
    elsif self.status.downcase.strip == "hold"
      @icon = 'offline.png'
    else
      @icon = 'offline.png'      
    end
  end
  
end
