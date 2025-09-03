# frozen_string_literal: true

Fabricator :user_playlist_save, class_name: 'User::PlaylistSave' do
  playlist { Fabricate(:playlist) }
  user { Fabricate(:user) }
end
