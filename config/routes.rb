Rails.application.routes.draw do
  
  resources :leagues
  resources :games
  resources :syncs
  resources :score_syncs
  
  devise_for :users
  
  root to: 'users#index'
  get "users/sign_up"
  get "users/sign_in"
  
end
