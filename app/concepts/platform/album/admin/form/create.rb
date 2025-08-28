# frozen_string_literal: true

module Platform::Album::Admin::Form
  class Create < ApplicationForm
    property :title, type: Types::StrippedString
    property :artist_id
    property :release_date
    property :cover

    validation do
      params do
        required(:title).filled(min_size?: 1)
        required(:artist_id).filled
        optional(:release_date)
        optional(:cover)
      end

      rule(:artist_id) do
        key.failure("Artist is not found!") unless Platform::Artist.exists?(id: value)
      end
    end
  end
end
