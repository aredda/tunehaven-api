# frozen_string_literal: true

module Platform::Artist::Admin::Form
  class Create < ApplicationForm
    property :name, type: Types::StrippedString
    property :about
    property :genre_ids

    validation do
      params do
        required(:name).filled(min_size?: 2)
        optional(:about)
        optional(:genre_ids).maybe(:array?)
      end

      rule(:name) do
        key.failure("This artist/band name already exists!") if Platform::Artist.exists?(slug: value.parameterize)
      end

      rule(:genre_ids) do
        if value.present?
          value.each do |genre_id|
            key.failure("[#{genre_id}] is not a valid genre!") unless Platform::Genre.exists?(id: genre_id)
          end
        end
      end
    end
  end
end
