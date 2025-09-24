# frozen_string_literal: true

module Platform::Genre::Admin::Form
  class Create < ApplicationForm
    property :name, type: Types::StrippedString
    property :description
    property :parent_id

    validation do
      params do
        required(:name).filled(min_size?: 2)
        optional(:description)
        optional(:parent_id)
      end

      rule(:name) do
        key.failure("The genre (#{value.parameterize}) already exists!") if Platform::Genre.exists?(id: value.parameterize)
      end

      rule(:parent_id) do
        key.failure("Genre is not found!") if !Platform::Genre.exists?(id: value) && value.present?
      end
    end
  end
end
