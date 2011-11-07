Vhpanel::Application.routes.draw do
  get "clients/index"

  get "front/index"
  
  resource :session
  match '/login' => "sessions#new", :as => "login"
  match '/logout' => "sessions#destroy", :as => "logout"
  
  get "/:action"=>"front"
  
  #clients points to users, pathname changed, 
  resources :users
  resources :clients, :controller=>'users',:path=>'superadmin/clients' do 
    collection do
      resources :subscriptions
    end
  end
  scope 'reseller' do
    get "/index",:as => "reseller_index"
    get "/login",:as => "reseller_login"
    get "/perl",:as => "perl_test"
    match '/edit' => 'reseller#edit', :via => [:get],:as=> 'reseller_edit'
    match '/reseller_update' => 'reseller#reseller_update', :via => [:post,:put],:as=> 'reseller_update'
    match 'password/change' =>"reseller#change_password",:as=>'reseller_update_password'
    match 'licence/upgrade/:left' =>"reseller#licence_upgrade",:as=>'reseller_licence_upgrade',:defaults=>{:left=>1}
    match 'licence/code/:left' =>"reseller#licence_code",:as=>'reseller_licence_code',:defaults=>{:left=>1}
    match '/download/:left' =>"reseller#download",:as=>'reseller_download',:defaults=>{:left=>1}
    match 'billing/history/:left' =>"reseller#billing_history",:as=>'reseller_billing_history',:defaults=>{:left=>2}
    match 'support/:left' =>"reseller#support_tickets",:as=>'reseller_all_support_tickets',:defaults=>{:left=>3}
    match 'support/:left/:show' =>"reseller#support_tickets",:as=>'reseller_open_support_tickets',:defaults=>{:left=>3,:show=>"open"}
    match 'support/:left/:show' =>"reseller#support_tickets",:as=>'reseller_hold_support_tickets',:defaults=>{:left=>3,:show=>"hold"}
    match 'support/:left/:show' =>"reseller#support_tickets",:as=>'reseller_closed_support_tickets',:defaults=>{:left=>3,:show=>"closed"}
    match 'support/:left/:show' =>"reseller#support_tickets",:as=>'reseller_progress_support_tickets',:defaults=>{:left=>3,:show=>"progress"}
    
    
    match '/new_password' =>"reseller#new_password",:as=>'reseller_new_password'
    match 'plan/summary' =>"reseller#plan_summary",:as=>'plan_summary'
    
    
    match '/perl' =>"reseller#perl_test",:as=>'perl_test'
  end
#  resources :subscriptions, :controller=>'subscriptions',:path=>'reseller/subscriptions'
    

   root :to => "front#index"
#   match ':controller(/:action(/:id(.:format)))'
#   match ':controller(/:action(.:format))'
end
