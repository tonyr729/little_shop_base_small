Rails.application.routes.draw do
  root to: 'welcome#index'

  resources :items, only: [:index, :show]
  resources :merchants, only: [:index]

  get '/cart', to: 'cart#index'
  get '/login', to: 'session#new'
  post '/login', to: 'session#create'
  get '/logout', to: 'session#destroy'

  get '/register', to: 'users#new', as: 'registration'
  resources :users, only: [:create, :update]

  get '/dashboard', to: 'merchants#show', as: 'dashboard'
  get '/profile', to: 'profile#index', as: 'profile'

  get '/profile/edit', to: 'users#edit'
  namespace :profile do
    resources :orders, only: [:index]
  end

  namespace :admin do
    resources :users, only: [:index, :show, :edit]
    resources :merchants, only: [:show]
    post '/users/:id/enable', to: 'users#enable', as: 'user_enable'
    post '/users/:id/disable', to: 'users#disable', as: 'user_disable'
    post '/users/:id/upgrade', to: 'users#upgrade', as: 'user_upgrade'
    post '/merchants/:id/enable', to: 'merchants#enable', as: 'merchant_enable'
    post '/merchants/:id/disable', to: 'merchants#disable', as: 'merchant_disable'
    resources :dashboard, only: [:index]
  end
end
