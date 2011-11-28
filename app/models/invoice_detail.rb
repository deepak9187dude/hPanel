class InvoiceDetail < ActiveRecord::Base
      belongs_to    :invoice_type
      belongs_to    :plan
      belongs_to    :user
      belongs_to    :ccdata
      belongs_to    :profile
      belongs_to    :gateway
      belongs_to    :subscription
      
   def status_image
    if self.gateway_pay_status.downcase.strip == "failed"
      @icon = 'offline.png'
    elsif self.gateway_pay_status.downcase.strip == "approved"
      @icon = 'online.png'
    else
      @icon = 'offline.png'      
    end
  end
end
