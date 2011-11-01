Vhpanel::Application.routes.draw do
  get "clients/index"

  get "front/index"
  
  
  get "/:action"=>"front"
  
  #clients points to users, pathname changed, 
  resources :users
  resources :clients, :controller=>'users',:path=>'superadmin/clients' do 
    collection do
      resources :subscriptions
    end
  end
  scope 'reseller' do
    match 'password/change' =>"reseller#change_password",:as=>'reseller_update_password'
    get "/index",:as => "reseller_index"
    get "/login",:as => "reseller_login"
    match '/edit' => 'reseller#edit', :via => [:get],:as=> 'reseller_edit'
    match '/reset' => 'reseller#reset_password', :via => [:get],:as=> 'reseller_reset_password'
    match '/reseller_update' => 'reseller#reseller_update', :via => [:post,:put],:as=> 'reseller_update'
  end
#  resources :subscriptions, :controller=>'subscriptions',:path=>'reseller/subscriptions'
    
  resource :session
  match '/login' => "sessions#new", :as => "login"
  match '/logout' => "sessions#destroy", :as => "logout"

   root :to => "front#index"
#   match ':controller(/:action(/:id(.:format)))'
#   match ':controller(/:action(.:format))'
end
