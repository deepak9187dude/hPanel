Vhpanel::Application.routes.draw do
  get "clients/index"

  get "reseller/index"
  get "front/index"
  get "/:action"=>"front"
  
  #clients points to users, pathname changed, 
  resources :users
  resources :clients, :controller=>'users',:path=>'reseller/clients' do 
    collection do
      resources :subscriptions
    end
  end
#  resources :subscriptions, :controller=>'subscriptions',:path=>'reseller/subscriptions'
    
  
   root :to => "front#index"
#   match ':controller(/:action(/:id(.:format)))'
#   match ':controller(/:action(.:format))'
end
