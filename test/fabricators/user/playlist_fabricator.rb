# frozen_string_literal: true

# == Schema Information
#
# Table name: user_playlists
#
#  id           :uuid             not null, primary key
#  description  :text
#  is_default   :boolean          default(FALSE)
#  title        :string           not null
#  tracks_count :integer          default(0)
#  visibility   :string           default(NULL)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :uuid             not null
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id) ON DELETE => cascade
#
Fabricator :playlist, class_name: 'User::Playlist' do
  user { Fabricate :user }
  title { Faker::Lorem.sentence }
end
