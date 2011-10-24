class User < ActiveRecord::Base
  has_one :user_plan   
  def self.authenticate(username, password)
    user = find_by_username(username)
    return user if user && user.authenticated?(password)
  end
  
  def authenticated?(password)
    self.password == password
  end
end
