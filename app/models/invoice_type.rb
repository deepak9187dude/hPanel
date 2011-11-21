class InvoiceType < ActiveRecord::Base
      has_many :invoice_details
end
