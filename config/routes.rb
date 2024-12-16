Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :v1 do
    namespace :admin do
      post "signup", to: "users#signup"
      post "signin", to: "users#signin"
      get "get_account", to: "users#get_account"
    end  
    post "register_product", to: "products#register"
    get "product/:id/details", to: "products#details"
    patch "product/:id/update", to: "products#update"
    delete "product/:id/remove", to: "products#remove"
    get "list_products", to: "products#list"
  end  
end
