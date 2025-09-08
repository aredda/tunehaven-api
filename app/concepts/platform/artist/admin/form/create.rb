# frozen_string_literal: true

module Platform::Artist::Admin::Form
  class Create < ApplicationForm
    property :name, type: Types::StrippedString
    property :about

    validation do
      params do
        required(:name).filled(min_size?: 2)
        optional(:about)
      end

      rule(:name) do
        key.failure("This band name already exists!") if Platform::Artist.exists?(slug: value.parameterize)
      end
    end
  end
end
