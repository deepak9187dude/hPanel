Vhpanel::Application.routes.draw do
  get "perl/index"
  get "perl/paypal"
  get "clients/index"
  get "front/index"
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
    
    match '/reseller_update' => 'reseller#reseller_update', :via => [:post,:put],:as=> 'reseller_update'
    match 'password/change' =>"reseller#change_password",:as=>'reseller_update_password'
    match 'licence/upgrade/:left' =>"reseller#licence_upgrade",:as=>'reseller_licence_upgrade',:defaults=>{:left=>1}
    match 'licence/payment/selection/:left/:plan_id/:plantype' =>"reseller#payment_selection",:as=>'reseller_payment_selection',:defaults=>{:left=>1}
    match 'licence/payment/upgrade/:left/:type' =>"reseller#upgrade_plan",:as=>'reseller_upgrade_plan',:defaults=>{:left=>1}
    match 'licence/gateway/payment/:left/:type' =>"reseller#gateway_payment",:as=>'gateway_payment',:defaults=>{:left=>1}
    match 'licence/code/:left' =>"reseller#licence_code",:as=>'reseller_licence_code',:defaults=>{:left=>1}
    match 'ssh/demo/:left' =>"reseller#ssh_demo",:as=>'ssh_demo',:defaults=>{:left=>1}
    match '/download/:left' =>"reseller#download",:as=>'reseller_download',:defaults=>{:left=>1}
    match 'billing/history/:left' =>"reseller#billing_history",:as=>'reseller_billing_history',:defaults=>{:left=>2}
    match 'billing/subscriptions/:left' =>"reseller#billing_subscriptions",:as=>'reseller_billing_subscriptions',:defaults=>{:left=>2}
    match 'subscription/:id/:left' =>"reseller#subscription_details",:as=>'reseller_subscriptions_details',:defaults=>{:left=>2}
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
    

   root :to => "front#index"
#   match ':controller(/:action(/:id(.:format)))'
#   match ':controller(/:action(.:format))'
end
