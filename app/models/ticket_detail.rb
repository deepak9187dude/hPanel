class TicketDetail < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :user,:foreign_key=>"replier_id"
end
