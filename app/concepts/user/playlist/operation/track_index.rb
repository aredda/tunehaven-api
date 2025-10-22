# frozen_string_literal: true

module User::Playlist::Operation
  class TrackIndex < Platform::Track::Operation::Show
    step :find_owned_playlists

    def find_owned_playlists(context, current_user:, **)
      context[:data] = current_user.playlists.order(is_default: :desc, title: :asc)
    end
  end
end
