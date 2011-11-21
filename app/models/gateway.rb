class Gateway < ActiveRecord::Base
      has_many  :invoice_details
end
