# frozen_string_literal: true

module User::PlaylistTrack::Operation
  class Show < ApplicationOperation
    step Subprocess(FetchPlaylist), Output(:failure) => Track(:end)
    step :find_model
    fall :fail_not_found

    def find_model(ctx, playlist:, params:, **)
      ctx[:model] = playlist.track_relationships.find_by(track_id: params[:id])
    end

    def fail_not_found_message(_context) = "Track is not found!"
  end
end
