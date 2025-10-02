# frozen_string_literal: true

module Platform::Track::Admin::Form
  class Create < ApplicationForm
    property :title, type: Types::StrippedString
    property :duration_in_seconds, type: Types::IntegerType
    property :album_id
    property :audio, virtual: true

    validation contract: BaseContract do
      params do
        required(:title).filled(min_size?: 1)
        required(:album_id).filled
        required(:audio).filled
        optional(:duration_in_seconds).maybe(:int?, gteq?: 0)
      end

      rule(:album_id) do
        key.failure("Album is not found!") unless Platform::Album.exists?(id: value)
      end

      rule(:audio).validate(:is_file?)
    end
  end
end
