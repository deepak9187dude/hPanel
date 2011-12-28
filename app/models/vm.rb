class Vm < ActiveRecord::Base
  belongs_to :user
  has_one :server_master
end
