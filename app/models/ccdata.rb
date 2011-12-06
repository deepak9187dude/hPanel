class Ccdata < ActiveRecord::Base
      belongs_to     :user
      
      def status_image
        if self.isActive == true
          @icon = 'online.png'
        else
          @icon = 'offline.png'      
        end
      end  
      
      def status_message
        if self.isActive == true
          @msg = 'Approved'
        else
          @msg = 'Pending'      
        end
      end  
      
end   
