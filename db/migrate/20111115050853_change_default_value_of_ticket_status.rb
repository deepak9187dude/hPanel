class ChangeDefaultValueOfTicketStatus < ActiveRecord::Migration
  def self.up
    change_column_default(:tickets, :status , 'Open')
  end

  def self.down
    change_column_default(:tickets, :status , nil)
  end
end
