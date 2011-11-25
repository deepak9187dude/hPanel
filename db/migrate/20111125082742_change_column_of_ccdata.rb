class ChangeColumnOfCcdata < ActiveRecord::Migration
  def self.up
      change_column :ccdata ,:exp_month ,:string
      change_column :ccdata ,:exp_year ,:string
  end

  def self.down
  end
end 
