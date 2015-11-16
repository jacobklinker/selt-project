Rails.application.routes.draw do
  
  devise_for :users, :controllers => { registrations: 'registrations' }
  
  devise_scope :user do
    authenticated :user do
      root 'users#index', as: :authenticated_root
    end
  
    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end
  get "leagues/accept_invite"
  post "leagues/add_user_to_league"
  resources :leagues
  resources :games
  resources :syncs
  resources :score_syncs
  
  get "users/sign_up"
  get "users/sign_in"
  
  get "games/picks"
  
  get "users/account_settings"
  
  
end
