Rails.application.routes.draw do
  root "home#landing"
  get "dashboard", to: "home#dashboard", as: :dashboard

  # Auth
  get    "login",  to: "sessions#new",     as: :login
  post   "login",  to: "sessions#create"
  delete "logout", to: "sessions#destroy", as: :logout

  # Inscription
  get  "signup", to: "users#new",    as: :signup
  post "signup", to: "users#create"

  # Profils utilisateurs
  resources :users, only: [:show, :edit, :update]

  # Compétences utilisateur
  resources :user_skills, only: [:create, :destroy]

  # Swaps
  resources :swaps, only: [:create, :update]

  # Messagerie
  resources :messages, only: [:index, :create]
  get "messages/:id", to: "messages#show", as: :message

  # Panel admin
  namespace :admin do
    root to: "users#index"
    resources :users,    except: [:new, :create]
    resources :skills
    resources :messages, only: [:new, :create]
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
