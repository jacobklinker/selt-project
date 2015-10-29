Rails.application.routes.draw do
  
  resources :games
  resources :syncs
  
  devise_for :users
  
  root to: 'users#index'
  get "users/sign_up"
  get "users/sign_in"
  
end
