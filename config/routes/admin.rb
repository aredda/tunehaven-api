# frozen_string_literal: true

namespace :admin do
  resource :me, controller: :me, only: :show

  resources :genres
  resources :artists do
    resources :genres, controller: "artists/genres"
  end
end
