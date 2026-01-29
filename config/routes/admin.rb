# frozen_string_literal: true

namespace :admin do
  resource :me, controller: :me, only: :show

  resources :genres do
    collection do
      get :autocomplete
    end
  end
  resources :artists do
    collection do
      get :autocomplete
    end

    resources :genres, controller: "artists/genres"
  end
  resources :albums do
    collection do
      get :autocomplete
    end

    member do
      put :metadata
    end

    resources :genres, controller: "albums/genres"
  end
  resources :tracks do
    member do
      put :move, path: "move/:position"
      get :stream
      put :transcode
    end

    collection do
      delete :/, action: :destroy_all
    end

    resources :genres, controller: "tracks/genres"
    resources :audios, controller: "tracks/audios"
  end

  resource :dashboard, controller: :dashboard do
    collection do
      get :stats
    end
  end

  scope :logs, module: :logs do
    resources :storage_sub_events
  end
end
