Rails.application.routes.draw do
  
  resources :games
  resources :syncs
  resources :score_syncs
  
  devise_for :users
  
  root to: 'users#index'
  get "users/sign_up"
  get "users/sign_in"
  
  get "users/account_settings"
  
end
