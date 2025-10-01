# frozen_string_literal: true

module Platform::Track::Admin::Form
  class Create < ApplicationForm
    property :title
    property :duration_in_seconds, type: Types::IntegerType
    property :album_id

    validation do
      params do
        required(:title).filled(min_size?: 1)
        optional(:duration_in_seconds).maybe(:int?, gteq?: 0)
        required(:album_id).filled
      end

      rule(:album_id) do
        key.failure("Album is not found!") unless Platform::Album.exists?(id: value)
      end
    end
  end
end
