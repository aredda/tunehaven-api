# frozen_string_literal: true

module Platform::Genre::Admin::Form
  class Create < ApplicationForm
    property :name, type: Types::StrippedString
    property :description

    validation do
      params do
        required(:name).filled(min_size?: 2)
        optional(:description)
      end
    end
  end
end
