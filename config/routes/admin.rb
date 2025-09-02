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
  resources :albums do
    resources :genres, controller: "albums/genres"
  end
  resources :tracks do
    resources :genres, controller: "tracks/genres"
    resources :audios, controller: "tracks/audios"
  end
end
