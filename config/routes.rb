Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks",
    registrations: "users/registrations"
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "homes#index"

  resources :posts, only: %i[new create index show edit update destroy] do
    member do
      post :track_official_click
    end
    resources :likes, only: %i[create destroy]
  end

  resource :profile, only: %i[show]

  resources :notifications, only: %i[index] do
    post :mark_notifications_as_read, on: :collection
  end

  resource :lookups, only: %i[create]

  resource :ranking, only: %i[show]
end
