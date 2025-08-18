# frozen_string_literal: true

module User::PlaylistTrack::Operation
  class Index < ApplicationOperation
    step Subprocess(FetchPlaylist), Output(:failure) => Track(:end)
    step :set_finder

    def set_finder(context, playlist:, params:, **)
      context[:finder] = User::PlaylistTrack::Finder::Paginated.new(entity: playlist.track_relationships.order(created_at: :desc), params:)
    end
  end
end
