# frozen_string_literal: true

module Platform::AlbumGenre::Admin::Form
  class Create < ApplicationForm
    property :genre_ids, virtual: true

    validation do
      option :form

      params do
        required(:genre_ids).filled(:array?)
      end

      rule(:genre_ids) do
        value.each do |genre_id|
          key.failure("Genre is not found!") unless Platform::Genre.exists?(id: genre_id)
          key.failure("This album is already associated with this genre: #{genre_id}") if form.model.album.genre_relationships.exists?(genre_id:)
        end
      end
    end
  end
end
