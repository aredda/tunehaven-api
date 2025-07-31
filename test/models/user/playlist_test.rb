# == Schema Information
#
# Table name: user_playlists
#
#  id           :uuid             not null, primary key
#  description  :text
#  title        :string           not null
#  tracks_count :integer          default(0)
#  visibility   :string           default("private")
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :uuid             not null
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id) ON DELETE => cascade
#
require "test_helper"

class User::PlaylistTest < ActiveSupport::TestCase
  context 'validations' do
    should have_db_column(:title)
    should have_db_column(:description)
    should have_db_column(:visibility)
    should have_db_column(:tracks_count)
  end

  context 'associations' do
    should belong_to(:user).class_name('User')

    should have_many(:track_relationships).class_name('User::PlaylistTrack')
    should have_many(:tracks).through(:track_relationships)
  end
end
