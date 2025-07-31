# frozen_string_literal: true

namespace :user do
  resource :me, controller: :me, only: :show
end
