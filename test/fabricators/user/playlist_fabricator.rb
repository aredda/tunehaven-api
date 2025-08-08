# frozen_string_literal: true

Fabricator :playlist, class_name: 'User::Playlist' do
  user { Fabricate :user }
end
