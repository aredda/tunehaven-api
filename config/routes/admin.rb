# frozen_string_literal: true

namespace :admin do
  resource :me, controller: :me, only: :show

  resources :genres
  resources :artists do
    collection do
      get :autocomplete
    end

    resources :genres, controller: "artists/genres"
  end
  resources :albums
  resources :tracks
end
