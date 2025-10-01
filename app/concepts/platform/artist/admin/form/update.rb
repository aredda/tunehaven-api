# frozen_string_literal: true

module Platform::Artist::Admin::Form
  class Update < ApplicationForm
    property :name
    property :about

    validation do
      option :form

      params do
        optional(:name)
      end

      rule(:name) do
        key.failure("This artist/band name already exists!") if Platform::Artist.where.not(id: form.model.id).exists?(slug: value.parameterize)
      end
    end
  end
end
