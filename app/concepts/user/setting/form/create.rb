# frozen_string_literal: true

module User::Setting::Form
  class Create < ApplicationForm
    property :settings

    validation do
      params do
        optional(:settings).maybe(:array?)
      end

      rule(:settings) do
        if value
          value.each do |entry|
            key.failure("Invalid input. Array should contain objects with a 'key' and a 'value' properties") if !entry.is_a?(Hash) || (!entry.keys.include?(:key) && !entry.keys.include?(:value))
          end
        end
      end
    end
  end
end
