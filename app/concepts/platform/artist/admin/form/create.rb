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
    end
  end
end
