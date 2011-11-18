class InvoiceDetail < ActiveRecord::Base
      belongs_to    :invoice_type
      belongs_to    :plan
      belongs_to    :user
      belongs_to    :ccdata
      belongs_to    :profile
      belongs_to    :gateway
end
