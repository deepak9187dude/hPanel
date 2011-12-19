Vhpanel::Application.routes.draw do
  get "perl/index"
  get "perl/paypal"
  get "clients/index"
  get "front/index"
  get "reseller/confirm"
  
  get "reseller/confirm"
  get "reseller/error"
  match "reseller/complete"=>"reseller#complete"
  
  get "BluePayBasic/DoBluePayPayment"
  match '/users' => "users#create", :via=>[:put,:post]
  
  resource :session
  match '/login' => "sessions#new", :as => "login"
  match '/logout' => "sessions#destroy", :as => "logout"
  
  match "/signinh/:plan_id/:plantype" => "front#signinh"
  match "/:action"=>"front"
  
  #clients points to users, pathname changed, 
  resources :users
  resources :clients, :controller=>'users',:path=>'superadmin/clients' do 
    collection do
      resources :subscriptions
    end
  end
  scope 'reseller' do
    get "/index",:as => "reseller_index"
    match "/login",:as => "reseller_login",:via=>[:get,:post,:put]
    match '/edit' => 'reseller#edit', :via => [:get],:as=> 'reseller_edit'
    match 'password/forgot' => 'reseller#forgot_password',:as=> 'reseller_forgot_password'
    match 'paypal/checkout(/:amount)' => 'reseller#checkout', :via => [:get,:post,:put],:as=> 'paypal_checkout'
    
    match '/reseller_update' => 'reseller#reseller_update', :via => [:post,:put],:as=> 'reseller_update'
    match 'password/change' =>"reseller#change_password",:as=>'reseller_update_password'
    match 'paymentmethod/create' => "reseller#create_payment_method", :as => 'reseller_create_payment_method', :via => [:post,:put]
    match 'paymentmethod/update/:id' => "reseller#update_payment_method", :as => 'reseller_update_payment_method', :via => [:post,:put]
    match 'paymentmethod/delete/:id' => "reseller#delete_payment_method", :as => 'reseller_delete_payment_method', :via => [:post,:put]
    
#    licence
    match 'licence/upgrade/:left' =>"reseller#licence_upgrade",:as=>'reseller_licence_upgrade',:defaults=>{:left=>1}
    match 'licence/payment/selection/:left/:plan_id/:plantype' =>"reseller#payment_selection",:as=>'reseller_payment_selection',:defaults=>{:left=>1}
    match 'licence/payment/upgrade/:left/:type' =>"reseller#upgrade_plan",:as=>'reseller_upgrade_plan',:defaults=>{:left=>1}
    match 'licence/gateway/payment/:left/:type' =>"reseller#gateway_payment",:as=>'gateway_payment',:defaults=>{:left=>1}
    match 'licence/code/:left' =>"reseller#licence_code",:as=>'reseller_licence_code',:defaults=>{:left=>1}
#   ssh download
    match 'ssh/demo/:left' =>"reseller#ssh_demo",:as=>'ssh_demo',:defaults=>{:left=>1}
    match '/download/:left' =>"reseller#download",:as=>'reseller_download',:defaults=>{:left=>1}
    
#    billing
    match 'billing/history/:left' =>"reseller#billing_history",:as=>'reseller_billing_history',:defaults=>{:left=>2}
    match 'billing/order/details/:left/:id' =>"reseller#order_details",:as=>'billing_order_details',:defaults=>{:left=>2}
    match 'billing/order/history/:left/:id' =>"reseller#order_history",:as=>'billing_order_history',:defaults=>{:left=>2}
    match 'billing/subscriptions/:left' =>"reseller#billing_subscriptions",:as=>'reseller_billing_subscriptions',:defaults=>{:left=>2}
    match 'billing/termination/:left' =>"reseller#billing_termination",:as=>'reseller_billing_termination',:defaults=>{:left=>2}
    match 'billing/payment/methods/:left' =>"reseller#payment_methods",:as=>'reseller_billing_payment_methods',:defaults=>{:left=>2}
    match 'billing/payment/methods/:left/new' =>"reseller#new_payment_method",:as=>'reseller_new_payment_method',:defaults=>{:left=>2}
    match 'billing/payment/methods/:left/edit/:id' =>"reseller#edit_payment_method",:as=>'reseller_edit_payment_method',:defaults=>{:left=>2}
    match 'subscription/:id/:left' =>"reseller#subscription_details",:as=>'reseller_subscriptions_details',:defaults=>{:left=>2}
    
#    vm manager
    match 'vm/:left' =>"reseller#view_all_vm",:as=>'vm',:defaults=>{:left=>1}
    match 'vm/:id/:left' =>"reseller#vm_details",:as=>'vm_details',:defaults=>{:left=>1}
    match 'vm/:id/password/:left' =>"reseller#vm_change_password",:as=>'vm_change_password',:defaults=>{:left=>1}
    match 'vm/:id/new/:left' =>"reseller#vm_new_password",:as=>'vm_new_password',:defaults=>{:left=>1}
    match 'vm/:id/processes/:left' =>"reseller#vm_processes",:as=>'vm_processes',:defaults=>{:left=>1}
    match 'vm/:id/services/:left' =>"reseller#vm_services",:as=>'vm_services',:defaults=>{:left=>1}
    match 'vm/:id/ssh/:left' =>"reseller#vm_ssh",:as=>'vm_ssh',:defaults=>{:left=>1}
    match 'vm/:id/delete/:left' =>"reseller#vm_delete",:as=>'vm_delete',:defaults=>{:left=>1}
    match 'vm/:id/boot/:left' =>"reseller#vm_boot",:as=>'vm_boot',:defaults=>{:left=>1}
    match 'vm/:id/shutdown/:left' =>"reseller#vm_shutdown",:as=>'vm_shutdwon',:defaults=>{:left=>1}
    match 'vm/:id/reboot/:left' =>"reseller#vm_reboot",:as=>'vm_reboot',:defaults=>{:left=>1}
    
#    tickets
    match 'support/:left' =>"reseller#support_tickets",:via => [:get,:post,:put],:as=>'reseller_all_support_tickets',:defaults=>{:left=>3}
    match 'support/:left/:show' =>"reseller#support_tickets",:via => [:get,:post,:put],:as=>'reseller_open_support_tickets',:defaults=>{:left=>3,:show=>"open"}
    match 'support/:left/:show' =>"reseller#support_tickets",:via => [:get,:post,:put],:as=>'reseller_hold_support_tickets',:defaults=>{:left=>3,:show=>"hold"}
    match 'support/:left/:show' =>"reseller#support_tickets",:via => [:get,:post,:put],:as=>'reseller_closed_support_tickets',:defaults=>{:left=>3,:show=>"closed"}
    match 'support/:left/:show' =>"reseller#support_tickets",:via => [:get,:post,:put],:as=>'reseller_progress_support_tickets',:defaults=>{:left=>3,:show=>"progress"} 
    
    match 'billing/:left' =>"reseller#billing_tickets",:via => [:get,:post,:put],:as=>'reseller_all_billing_tickets',:defaults=>{:left=>3}
    match 'billing/:left/:show' =>"reseller#billing_tickets",:via => [:get,:post,:put],:as=>'reseller_open_billing_tickets',:defaults=>{:left=>3,:show=>"open"}
    match 'billing/:left/:show' =>"reseller#billing_tickets",:via => [:get,:post,:put],:as=>'reseller_hold_billing_tickets',:defaults=>{:left=>3,:show=>"hold"}
    match 'billing/:left/:show' =>"reseller#billing_tickets",:via => [:get,:post,:put],:as=>'reseller_closed_billing_tickets',:defaults=>{:left=>3,:show=>"closed"}
    match 'billing/:left/:show' =>"reseller#billing_tickets",:via => [:get,:post,:put],:as=>'reseller_progress_billing_tickets',:defaults=>{:left=>3,:show=>"progress"} 
    
    match 'tickets/:left/new' => "reseller#new_ticket", :as => 'reseller_new_ticket',:defaults=>{:left=>3}
    match 'tickets/create' => "reseller#create_ticket", :as => 'reseller_create_ticket', :via => [:post,:put]
    match 'tickets/:left/:page(/:id)' => "reseller#ticket_details", :as => 'reseller_ticket_details',:defaults=>{:left=>3,:page=>'general'}
    match 'ticket_reply/create_reply/:id' => "reseller#create_reply", :as => 'create_reply'
    
    match '/new_password' =>"reseller#new_password",:as=>'reseller_new_password'
    match 'plan/summary' =>"reseller#plan_summary",:as=>'plan_summary'    
    match '/perl' =>"reseller#perl_test",:as=>'perl_test'
  end
#  resources :subscriptions, :controller=>'subscriptions',:path=>'reseller/subscriptions'
    
#   admin section routes
scope 'admin' do
  match "/index(/:left)"=>"admin#index",:as => "admin",:via=>[:get,:post,:put],:defaults=>{:left=>'i'}
#  resources :users
#  admin client manager
  match "/clients/all"=>"admin_clients#view_all_clients",:as=>"admin_all_clients"
  match "/clients/add"=>"admin_clients#add_new_client",:as=>"admin_new_client"
  match "/subscriptions/:type"=>"admin#admin_subscriptions",:as=>"admin_subscriptions",:defaults=>{:type=>'all'}
#  match "/subscriptions/onhold"=>"admin#subscriptions_on_hold",:as=>"admin_subscriptions_on_hold"
#  match "/subscriptions/expired"=>"admin#subscriptions_expired",:as=>"admin_subscriptions_expired"
#  match "/subscriptions/termination"=>"admin#subscriptions_termination_queue",:as=>"admin_subscriptions_termination_queue"
#  match "/subscriptions/failed"=>"admin#subscriptions_failed",:as=>"admin_subscriptions_failed"
  match "/settings/graceperiod"=>"admin#grace_period_settings",:as=>"grace_period_settings"
  match "/billing/termination"=>"admin#termination_request",:as=>"termination_request"
  
    
#  admin server manager
  match "/server/viewall/:left"=>"admin_servers#view_all_servers",:as=>"admin_servers",:defaults=>{:left=>'1'}
  match "/server/add/:left"=>"admin_servers#add_new_server",:as=>"admin_new_server",:defaults=>{:left=>'1'}
  match "/server/view/vm/:left"=>"admin_servers#view_vm_on_server",:as=>"admin_view_vm_on_server",:defaults=>{:left=>'1'}
  match "/server/device/:left"=>"admin_servers#device_management",:as=>"admin_device_management",:defaults=>{:left=>'1'}
  match "/server/template/:left"=>"admin_servers#template_management",:as=>"admin_template_management",:defaults=>{:left=>'1'}
  match "/server/network/ipmanager/:left"=>"admin_servers#ip_manager",:as=>"admin_ip_manager",:defaults=>{:left=>'1'}
  match "/server/network/ipblocked/:left"=>"admin_servers#blocked_ip",:as=>"admin_blocked_ip",:defaults=>{:left=>'1'}
  match "/server/network/nameserver/:left"=>"admin_servers#resolver_management",:as=>"admin_resolver_management",:defaults=>{:left=>'1'}
  match "/server/password/reset/:left"=>"admin_servers#reset_password",:as=>"admin_server_reset_password",:defaults=>{:left=>'1'}
  
    
#  admin server manager
  match "/vms/all/:left"=>"admin_vms#view_all_vm",:as=>"admin_all_vms",:defaults=>{:left=>2}
  match "/vms/new/:left"=>"admin_vms#add_new_vm",:as=>"admin_new_vm",:defaults=>{:left=>2}
  match "/vms/:id/details/:left"=>"admin_vms#vm_details",:as=>"admin_vm_details",:defaults=>{:left=>2}
  
#    admin billing manager
  match "/billing/hosting/plans/:left"=>"admin_billings#hosting_plans",:as=>"billing_hosting_plans",:defaults=>{:left=>3}
  match "/billing/receivables/:left/:receivable"=>"admin_billings#receivables",:as => "billing_reveivables",:defaults=>{:left=>3,:receivable=>'orders'}
  
#    admin logs  
  match "/logs/jobs/:type/:left"=>"admin_logs#jobs_queue",:as=>"jobs_queue",:defaults=>{:left=>4,:type=>'completed'}
  match "/logs/jong/:type/:left"=>"admin_logs#long_queue",:as=>"long_queue",:defaults=>{:left=>4,:type=>'completed'}
  
#   admin commerce manager
  match "/commerce/fraud/:left"=>"admin_billings#anti_fraud_checklist",:as=>"anti_fraud_checklist",:defaults=>{:left=>5}
  match "/gateway/settings/:left"=>"admin_billings#gateway_settings",:as=>"gateway_settings",:defaults=>{:left=>5}
  match "/gateway/fraudscore/:left"=>"admin_billings#fraud_score",:as=>"fraud_score",:defaults=>{:left=>5}

# admin settings 
  match "/password/reset/:left"=>"admin#reset_password",:as=>"admin_reset_password",:defaults=>{:left=>6}
  
    
#  admin tickets
    match 'support/:left' =>"admin_tickets#support_tickets",:via => [:get,:post,:put],:as=>'admin_all_support_tickets',:defaults=>{:left=>7}
    match 'support/:left/:show' =>"admin_tickets#support_tickets",:via => [:get,:post,:put],:as=>'admin_open_support_tickets',:defaults=>{:left=>7,:show=>"open"}
    match 'support/:left/:show' =>"admin_tickets#support_tickets",:via => [:get,:post,:put],:as=>'admin_hold_support_tickets',:defaults=>{:left=>7,:show=>"hold"}
    match 'support/:left/:show' =>"admin_tickets#support_tickets",:via => [:get,:post,:put],:as=>'admin_closed_support_tickets',:defaults=>{:left=>7,:show=>"closed"}
    match 'support/:left/:show' =>"admin_tickets#support_tickets",:via => [:get,:post,:put],:as=>'admin_progress_support_tickets',:defaults=>{:left=>7,:show=>"progress"} 
    
    match 'billing/:left' =>"admin_tickets#billing_tickets",:via => [:get,:post,:put],:as=>'admin_all_billing_tickets',:defaults=>{:left=>7}
    match 'billing/:left/:show' =>"admin_tickets#billing_tickets",:via => [:get,:post,:put],:as=>'admin_open_billing_tickets',:defaults=>{:left=>7,:show=>"open"}
    match 'billing/:left/:show' =>"admin_tickets#billing_tickets",:via => [:get,:post,:put],:as=>'admin_hold_billing_tickets',:defaults=>{:left=>7,:show=>"hold"}
    match 'billing/:left/:show' =>"admin_tickets#billing_tickets",:via => [:get,:post,:put],:as=>'admin_closed_billing_tickets',:defaults=>{:left=>7,:show=>"closed"}
    match 'billing/:left/:show' =>"admin_tickets#billing_tickets",:via => [:get,:post,:put],:as=>'admin_progress_billing_tickets',:defaults=>{:left=>7,:show=>"progress"} 
    
    match 'tickets/:left/new' => "admin_tickets#new_ticket", :as => 'admin_new_ticket',:defaults=>{:left=>7}
    match 'tickets/create' => "admin_tickets#create_ticket", :as => 'admin_create_ticket', :via => [:post,:put]
    match 'tickets/:left/:page(/:id)' => "admin_tickets#ticket_details", :as => 'admin_ticket_details',:defaults=>{:left=>7,:page=>'general'}
    match 'ticket_reply/create_reply/:id' => "admin_tickets#create_reply", :as => 'admin_create_reply'

end
   root :to => "front#index"
#   match ':controller(/:action(/:id(.:format)))'
#   match ':controller(/:action(.:format))'
end
