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
require "test_helper"

class User::PlaylistSaveTest < ActiveSupport::TestCase
  context "associations" do
    should belong_to(:user).class_name("User")
    should belong_to(:playlist).class_name("User::Playlist")
  end
end
