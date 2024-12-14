Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :v1 do
    namespace :admin do
      post "signup", to: "users#signup"
      post "signin", to: "users#signin"
      get "get_account", to: "users#get_account"
    end  
  end  
end
