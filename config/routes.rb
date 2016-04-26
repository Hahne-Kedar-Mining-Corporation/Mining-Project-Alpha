Rails.application.routes.draw do
  root to: 'tools#index'
  get "admin/tools", to: "admin/tools#index"

  namespace :admin do
    get "/dashboard", to: "users#show"
    # get "/tools", to: "tools#index"
    resources :tools, only: [:create, :new, :edit]
  end

  get "/login", to: "sessions#new", as: :login
  post "/login", to: "sessions#create", as: :session_users
  get "/cart/login", to: "sessions#cart_login", as: :cart_login
  resources :orders, only: [:index, :create, :show]

  resources :tools, only: [:index, :show]

  resources :users, only: [:new, :index, :create, :edit, :update]
  get "/users/:id", to: "users#show", as: :dashboard
  delete "/users/logout", to: "sessions#destroy", as: :logout

  resources :cart_tools, only: [:create, :destroy]
  resource :cart, only: [:show, :update]
  put "/cart_tools", to: "cart_tools#update"
  get "/:category_name", to: 'categories#view', as: :category_name

end
