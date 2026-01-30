# frozen_string_literal: true

module User::Operation
  class Search < ApplicationOperation
    step :set_finder
    fall :fail_invalid_type

    def set_finder(context, params:, **)
      entity = case params[:type]
      when "track" then Platform::Track
      when "album" then Platform::Album.order(likes_count: :desc)
      when "artist" then Platform::Artist
      when "playlist" then User::Playlist.visibility_public.order(likes_count: :desc)
      else return false
      end

      context[:finder] = User::Finder::Search.new(entity:, params: params.to_unsafe_h)
    end

    def fail_invalid_type(context, **)
      fail_error(context, "Invalid type: must be either 'track', 'album', 'artist' or 'playlist'")
    end
  end
end
