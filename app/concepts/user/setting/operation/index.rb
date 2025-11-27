# frozen_string_literal: true

module User::Setting::Operation
  class Index < ApplicationOperation
    step :fetch_settings

    def fetch_settings(context, current_user:, **)
      context[:model] = current_user.settings
    end
  end
end
