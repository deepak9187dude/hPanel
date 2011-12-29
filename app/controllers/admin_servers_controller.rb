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
  
  def edit_server
    @server = ServerMaster.find(params[:id])
  end
  
  def update_server
    if params[:server]
      @server = ServerMaster.find(params[:id])
      @server.update_attributes(params[:server])
      redirect_to admin_edit_server_path(params[:id])    
    end
  end
  
  def delete_server
    
  end
  
  def reset_password
    @vm = Vm.all
    @selected_vm = Vm.find(params[:id])
  end
end
