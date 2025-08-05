# frozen_string_literal: true

namespace :user do
  resource :me, controller: :me, only: :show

  resources :tracks do
    member do
      put :toggle_like
    end
  end
end
