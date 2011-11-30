class User < ActiveRecord::Base
  has_one :user_plan
  has_many :tickets
  has_many :ticket_details
  has_many :subscriptions
  has_many :invoice_details
  has_many :vms
  
  def self.authenticate(username, password)
      user = find_by_email(username) if !user = find_by_username(username)
      return user if user && user.authenticated?(password)
  end

  def authenticated?(password)
    self.password == password
  end

  def name
    self.first_name + " " + self.last_name
  end

  def mobile
    if @mobile = self.mccode + " " + self.macode + " " + self.mnumber
      @mobile
    else
      @mobile=""
    end
  end

  def phone
    @phone_number =  "#{self.phccode} #{self.phacode} #{self.phnumber}"
  end

  def fax
    @fax_number = "#{self.fccode} #{self.facode}  #{self.fnumber}"
  end
end
