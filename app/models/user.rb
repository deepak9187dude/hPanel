class User < ActiveRecord::Base
      has_one :user_plan
end
