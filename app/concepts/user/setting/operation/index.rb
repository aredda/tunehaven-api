# frozen_string_literal: true

module User::Setting::Operation
  class Index < ApplicationOperation
    step :has_no_default_settings, Output(:failure) => Id(:fetch_settings)
    step :create_default_settings
    step :fetch_settings

    def has_no_default_settings(_context, current_user:, **)
      current_user.settings.count.zero?
    end

    def create_default_settings(_context, current_user:, **)
      current_user.create_default_settings
      current_user.save
    end

    def fetch_settings(context, current_user:, **)
      context[:model] = current_user.settings
    end
  end
end
