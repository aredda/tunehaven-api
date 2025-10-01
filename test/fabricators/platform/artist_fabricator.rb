# frozen_string_literal: true

# == Schema Information
#
# Table name: platform_artists
#
#  id           :uuid             not null, primary key
#  about        :text
#  albums_count :integer          default(0)
#  name         :citext           not null
#  slug         :citext
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
Fabricator :artist, class_name: "Platform::Artist" do
  name { Faker::Music.band }
end
