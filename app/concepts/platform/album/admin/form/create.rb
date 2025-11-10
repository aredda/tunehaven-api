# frozen_string_literal: true

module Platform::Album::Admin::Form
  class Create < ApplicationForm
    property :title, type: Types::StrippedString
    property :artist_id
    property :release_date
    property :cover
    property :genre_ids

    validation do
      option :form

      params do
        required(:title).filled(min_size?: 1)
        required(:artist_id).filled
        optional(:release_date)
        optional(:cover)
        optional(:genre_ids).maybe(:array?)
      end

      rule(:artist_id) do
        key.failure("Artist is not found!") unless Platform::Artist.exists?(id: value)
      end

      rule(:title) do
        artist = Platform::Artist.find(form.artist_id)

        key.failure("This album is already added!") if Platform::Album.exists?(slug: [ artist.slug, value ].join("-").parameterize)
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
