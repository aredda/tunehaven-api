# == Schema Information
#
# Table name: user_album_saves
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  album_id   :uuid             not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_user_album_saves_on_user_id_and_album_id  (user_id,album_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (album_id => platform_albums.id)
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class User::AlbumSaveTest < ActiveSupport::TestCase
  context "associations" do
    should belong_to(:user)
    should belong_to(:album).class_name("Platform::Album")
  end
end
