# frozen_string_literal: true

module Platform::AlbumGenre::Admin::Operation
  class Index < ApplicationOperation
    step Model::Find(Platform::Album, find_by: :id, params_key: :album_id)
    fall :fail_not_found
    step :set_finder

    def fail_not_found_message(_context)
      "Album is not found!"
    end

    def set_finder(context, model:, params:, **)
      context[:finder] = Platform::AlbumGenre::Admin::Finder::Base.new(entity: model.genre_relationships.order(created_at: :desc), params:)
    end
  end
end
