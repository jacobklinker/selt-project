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
  
  get "games/picks/:league_id", to: 'games#picks', as: 'games_picks'
  post "games/submit_picks/:league_id", to: "games#submit_picks", as: "games_submit_picks"
  get "games/show_picks/:league_id/:user_id", to: 'games#show_picks', as: "show_picks"
  get "games/show_all_picks/:league_id", to: 'games#show_all_picks', as: "show_all_picks"
  
  get "users/account_settings"
  
  post 'leagues/add_announcement/:league_id', to: 'leagues#add_announcement', as: 'leagues_add_announcements'
  get 'leagues/set_tiebreaker/:league_id', to:'leagues#set_tiebreaker', as: 'leagues_set_tiebreaker'
  post "games/submit_tiebreaker/:league_id", to: "leagues#submit_tiebreaker", as: "leagues_submit_tiebreaker"
  post 'leagues/create_announcement/:league_id', to: 'leagues#create_announcement', as: 'create_announcement'
end
