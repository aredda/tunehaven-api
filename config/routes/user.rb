# frozen_string_literal: true

namespace :user do
  post :sign_up, controller: :registrations, action: :create

  resource :password, controller: :password, except: [] do
    collection do
      post :forget
      post :reset
    end
  end

  resource :me, controller: :me, only: :show

  resources :tracks do
    member do
      get :stream
      put :toggle_like
    end
  end
  resources :playlists do
    member do
      put :toggle_visibility
    end

    resources :tracks, controller: "playlists/tracks", only: %i[index create destroy]
  end
  resource :search, controller: :search, only: :show
end
