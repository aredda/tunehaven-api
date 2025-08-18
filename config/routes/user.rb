# frozen_string_literal: true

namespace :user do
  resource :me, controller: :me, only: :show

  resources :tracks do
    member do
      put :toggle_like
    end
  end
  resources :playlists do
    resources :tracks, controller: "playlists/tracks", only: %i[index create destroy]
  end
end
