# frozen_string_literal: true

# == Schema Information
#
# Table name: user_playlist_saves
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  playlist_id :uuid             not null
#  user_id     :uuid             not null
#
# Indexes
#
#  index_user_playlist_saves_on_user_id_and_playlist_id  (user_id,playlist_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (playlist_id => user_playlists.id)
#  fk_rails_...  (user_id => users.id)
#
Fabricator :user_playlist_save, class_name: "User::PlaylistSave" do
  playlist { Fabricate(:playlist) }
  user { Fabricate(:user) }
end
