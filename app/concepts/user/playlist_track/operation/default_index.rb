# frozen_string_literal: true

module User::PlaylistTrack::Operation
  class DefaultIndex < ApplicationOperation
    step :set_finder

    def set_finder(context, current_user:, params:, **)
      context[:finder] = User::PlaylistTrack::Finder::Paginated.new(entity: current_user.liked_playlist.track_relationships.order(created_at: :desc), params:)
    end
  end
end
