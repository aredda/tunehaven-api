# frozen_string_literal: true

module User::PlaylistTrack::Operation
  class FetchPlaylist < ApplicationOperation
    step :find_playlist
    fall :fail_not_found

    def find_playlist(ctx, current_user:, params:, **)
      ctx[:playlist] = current_user.playlists.find_by(id: params[:playlist_id])
    end

    def fail_not_found_message(_context)
      "Playlist is not found"
    end
  end
end
