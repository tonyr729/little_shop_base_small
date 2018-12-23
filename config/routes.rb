Rails.application.routes.draw do
  root to: 'welcome#index'

  resources :items, only: [:index]
  resources :merchants, only: [:index]
  get '/cart', to: 'cart#index'
  get '/login', to: 'session#new'
  get '/register', to: 'users#new', as: 'registration'
end
