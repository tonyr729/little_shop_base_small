Rails.application.routes.draw do
  root to: 'welcome#index'

  resources :items, only: [:index, :show]
  resources :merchants, only: [:index]

  get '/cart', to: 'cart#index'
  post '/cart/additem/:id', to: 'cart#add_item', as: 'cart_add_item'
  post '/cart/addmoreitem/:id', to: 'cart#add_more_item', as: 'cart_add_more_item'
  delete '/cart', to: 'cart#destroy', as: 'cart_empty'
  delete '/cart/item/:id', to: 'cart#remove_more_item', as: 'cart_remove_more_item'
  delete '/cart/item/:id/all', to: 'cart#remove_all_of_item', as: 'cart_remove_item_all'

  get '/login', to: 'session#new'
  post '/login', to: 'session#create'
  get '/logout', to: 'session#destroy'

  get '/register', to: 'users#new', as: 'registration'
  resources :users, only: [:create, :update]

  get '/dashboard', to: 'merchants#show', as: 'dashboard'
  namespace :dashboard do
    resources :orders, only: [:show] do
      post '/items/:id/fulfill', to: 'orders#fulfill_item', as: 'item_fulfill'
    end
    resources :items, except: [:show]
    patch '/items/:id/enable', to: 'items#enable', as: 'enable_item'
    patch '/items/:id/disable', to: 'items#disable', as: 'disable_item'
  end
  get '/profile', to: 'profile#index', as: 'profile'

  get '/profile/edit', to: 'users#edit'
  namespace :profile do
    resources :orders, only: [:index, :create, :show, :destroy]
  end

  namespace :admin do
    resources :users, only: [:index, :show, :edit]
    resources :merchants, only: [:show]
    post '/users/:id/enable', to: 'users#enable', as: 'user_enable'
    post '/users/:id/disable', to: 'users#disable', as: 'user_disable'
    post '/users/:id/upgrade', to: 'users#upgrade', as: 'user_upgrade'
    post '/merchants/:id/enable', to: 'merchants#enable', as: 'merchant_enable'
    post '/merchants/:id/disable', to: 'merchants#disable', as: 'merchant_disable'
    post '/merchants/:id/upgrade', to: 'merchants#downgrade', as: 'merchant_downgrade'
    resources :dashboard, only: [:index]
  end
end
