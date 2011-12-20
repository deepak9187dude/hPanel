class Gateway < ActiveRecord::Base
      has_many  :invoice_details
      def status_image
        if self.isEnabled == false
        @icon = 'offline.png'
        elsif self.isEnabled == true
        @icon = 'online.png'
        else
        @icon = 'offline.png'      
        end
      end
      
      
      def status_msg
        if self.isEnabled == false
        @msg = 'Disabled'
        elsif self.isEnabled == true
        @msg = 'Active'
        else
        @msg = 'Disabled'
        end
      end
end
