Rails.application.routes.draw do
  root to: 'welcome#index'

  resources :items, only: [:index]
  resources :merchants, only: [:index]
  
  get '/cart', to: 'cart#index'
  get '/login', to: 'session#new'
  get '/logout', to: 'session#destroy'
  
  get '/register', to: 'users#new', as: 'registration'
  resources :users, only: [:create]

  get '/dashboard', to: 'merchants#show', as: 'dashboard'
  get '/profile', to: 'profile#index', as: 'profile'

  namespace :profile do
    resources :orders, only: [:index]
  end

  namespace :admin do
    resources :users, only: [:index]
    resources :dashboard, only: [:index]
  end

  # custom error pages
  get "/404", to: "errors#not_found"
  get "/422", to: "errors#unacceptable"
  get "/500", to: "errors#internal_error"
end
