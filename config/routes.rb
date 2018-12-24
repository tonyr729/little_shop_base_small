Rails.application.routes.draw do
  root to: 'welcome#index'

  resources :items, only: [:index]
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
    resources :users, only: [:index]
    resources :dashboard, only: [:index]
  end
end
