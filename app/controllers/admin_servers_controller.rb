class AdminServersController < ApplicationController
  layout 'admin_backend'   
  before_filter :admin_current_user
    
  def view_all_servers
    @vms = Vm.all
  end
  
  def add_new_server
    
  end
  
  def admin_view_vm_on_server
    
  end
  
  def template_management
    
  end
  
  def ip_manager
    
  end
  
  def blocked_ip
    
  end
end
