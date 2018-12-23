Rails.application.routes.draw do
  root to: 'welcome#index'

  resources :items, only: [:index]
  resources :merchants, only: [:index]

  get '/cart', to: 'cart#index'
  get '/login', to: 'session#new'
  get '/logout', to: 'session#destroy'
  get '/register', to: 'users#new', as: 'registration'

  get '/dashboard', to: 'merchants#show', as: 'dashboard'
  get '/profile', to: 'profile#index', as: 'profile'
  namespace :profile do
    resources :orders, only: [:index]
  end
end
