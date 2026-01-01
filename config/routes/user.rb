# frozen_string_literal: true

namespace :user do
  post :sign_up, controller: :registrations, action: :create

  resource :password, controller: :password, except: [] do
    collection do
      post :forget
      post :reset
      get :verify
    end
  end

  resource :me, controller: :me, only: :show

  resources :tracks do
    member do
      get :stream
      put :toggle_like
      get :playlists
    end
  end
  resources :playlists do
    member do
      put :toggle_visibility
      post :toggle_save
    end

    resources :tracks, controller: "playlists/tracks", only: %i[index create destroy]
  end
  resources :albums do
    member do
      post :toggle_save
    end
  end
  resources :artists, only: %i[index show]
  resources :genres, only: %i[index show] do
    collection do
      get :featured
    end
    member do
      get :albums
    end
  end
  resource :library, controller: :library do
    collection do
      get :recent
    end
  end

  resource :search, controller: :search, only: :show

  resources :settings, only: %i[index create]
end
