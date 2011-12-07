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
          @msg = 'Active'
        else
          @msg = 'Disabled'      
        end
      end  
      
    def mask(number)
         "XXXX-XXXX-XXXX-#{last_digits(number)}"
    end
    
    def last_digits(number)    
      number.to_s.length <= 4 ? number : number.to_s.slice(-4..-1) 
    end

end   
