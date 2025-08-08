# frozen_string_literal: true

Fabricator :user_playlist_track, class_name: 'User::PlaylistTrack' do
  track { Fabricate(:track) }
  playlist { Fabricate(:playlist) }
end
