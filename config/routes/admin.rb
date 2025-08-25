# frozen_string_literal: true

namespace :admin do
  resource :me, controller: :me, only: :show
end
