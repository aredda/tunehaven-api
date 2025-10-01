# frozen_string_literal: true

Fabricator :artist, class_name: "Platform::Artist" do
  name { Faker::Music.band }
end
